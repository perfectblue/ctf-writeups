ccls-fringe
===========

```
Ray said that the challenge "Leaf-Similar Trees" from last LeetCode Weekly was really 
same-fringe problem and wrote it in the form of coroutine which he learned from a
Stanford friend. Can you decrypt the cache file dumped from a language server without 
reading the source code? The flag is not in the form of rwctf{} because special
characters cannot be used.

Downloads: ccls-fringe.tar.xz
```

-------------------------------

The downloaded archive, contained a single file in `.ccls-cache/@home@flag@/fringe.cc.blob`. Upon
inspecting the file, it looked like a binary file with a lot of C++ function and class names. It wasn't a
ELF binary or anything of that sort, just simple binary data.

Searching for ccls pointed us to https://github.com/MaskRay/ccls, and searching for `blob` in the repository, we find this:

```cpp
// https://github.com/MaskRay/ccls/blob/b4aa0705a1c421d16c0c3f98a2542f6f6285dae0/src/pipeline.cc#L102
std::string AppendSerializationFormat(const std::string& base) {
  switch (g_config->cacheFormat) {
    case SerializeFormat::Binary:
      return base + ".blob";
    case SerializeFormat::Json:
      return base + ".json";
  }
}
```

So, the file we're given is the serialized index cache of the ccls Language Server.
The binary format is difficult to read, but if we can convert it to json, it can be much better.

To do this, we clone the project and modify the `main` function to load the binary cache, parse it
and print it as json.

```cpp
int main(int argc, char** argv) {
  std::optional<std::string> serialized_indexed_content =
      ReadContent("fringe.cc.blob");

  std::unique_ptr<IndexFile> result =
    ccls::Deserialize(SerializeFormat::Binary, "fringe.cc",
                      *serialized_indexed_content, "",
                      IndexFile::kMajorVersion);
  std::string actual = result->ToString();
  std::cout << actual << std::endl;
  return 0;
}
```

The output from this is a well formatted json file of the entire index:
https://gist.github.com/amit15061999/a5394f57db4d5acc71d0ef04de725401

In this file, we notice 3 different main sections: usr2func, usr2type, and usr2var; which one can deduce
as the functions, types and variables in the file.

Each object has it's detailed_name (declaration) and a spell and a extent property,
which is in a special format. If we look at the ccls source, we can see that spell and extent
are objects of type `Use`.

```cpp
// https://github.com/MaskRay/ccls/blob/b4aa0705a1c421d16c0c3f98a2542f6f6285dae0/src/indexer.h#L88
struct FuncDef : NameMixin<FuncDef> {
  // General metadata.
  const char* detailed_name = "";
  const char* hover = "";
  const char* comments = "";
  Maybe<Use> spell;
  Maybe<Use> extent;
```

If we look at how the `Use` struct is serialized, we can understand what this format means.

```cpp
// https://github.com/MaskRay/ccls/blob/b4aa0705a1c421d16c0c3f98a2542f6f6285dae0/src/indexer.cc#L1321
void Reflect(Writer& vis, Use& v) {
  if (vis.Format() == SerializeFormat::Json) {
    char buf[99];
    if (v.file_id == -1)
      snprintf(buf, sizeof buf, "%s|%" PRIu64 "|%d|%d",
               v.range.ToString().c_str(), v.usr, int(v.kind), int(v.role));
```

This means, the the first part of the `spell` and `extent` tells us the range of the object
in lines and column numbers. Using this info, we can reconstruct the source line by line, by
searching for the objects which have the line number in the `spell` and `extent` property.

```cpp
#include <iostream>
#include <vector>
#include <ucontext.h>
using namespace std;

struct TreeNode {
  int val;
  TreeNode *left;
  TreeNode *right;
};

struct Co {
  ucontext_t c;
  char stack[8192];
  TreeNode *ret;
  Co(ucontext_t *link, void (*f)(Co *, TreeNode *), TreeNode *root) {      int b;  // flag is here
                                                                           int l;
                                                                           int e;
                                                                           int s;
                                                                           int s;

  }
  void yield(TreeNode *x) {                                                int w;
                                                                           int o;
                                                                           int d;
```

After, reconstruction about 25 line of the code, we can notice the pattern here that
the flag characters are variables in the `76-81` column range. So, we can just find all
variables matching this, and get the flag instead of reconstruction the entire file.

The flag turns out to be `bless wod whois inhk`, which you have to submit without spaces
