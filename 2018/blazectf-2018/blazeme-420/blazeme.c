#include <linux/module.h>
#include <linux/version.h>
#include <linux/kernel.h>
#include <linux/types.h>
#include <linux/kdev_t.h>
#include <linux/fs.h>
#include <linux/device.h>
#include <linux/cdev.h>
#include <linux/uaccess.h>
#include <linux/slab.h>

#define DEVICE_NAME "blazeme"

#define ERR_BLAZEME_OK (1)
#define ERR_BLAZEME_MALLOC_FAIL (2)

#define KBUF_LEN (64)

dev_t dev = 0;
static struct cdev cdev;
static struct class *blazeme_class;

ssize_t blazeme_read(struct file *file, char __user *buf, size_t count,
								loff_t *ppos);
ssize_t blazeme_write(struct file *file, const char __user *buf,
		size_t count, loff_t *ppos);

int blazeme_open(struct inode *inode, struct file *file);
int blazeme_close(struct inode *inode, struct file *file);

char *kbuf;

struct file_operations blazeme_fops =  
{  
    .owner           = THIS_MODULE,  
    .read            = blazeme_read,       
    .write           = blazeme_write,         
    .open            = blazeme_open,       
    .release         = blazeme_close,    
};  

ssize_t blazeme_read(struct file *file, char __user *buf, size_t count,
								loff_t *ppos) {
	int len = count;
	ssize_t ret = ERR_BLAZEME_OK;
	
	if (len > KBUF_LEN || kbuf == NULL) {
		ret = ERR_BLAZEME_OK;
		goto out;
	}

	if (copy_to_user(buf, kbuf, len)) {
		goto out;
	}

	return (ssize_t)len;

out:
	return ret;
}

ssize_t blazeme_write(struct file *file,
						const char __user *buf,
						size_t count, loff_t *ppos) {
	char str[512] = "Hello ";
	ssize_t ret = ERR_BLAZEME_OK;

	if (buf == NULL) {
		printk(KERN_INFO "blazeme_write get a null ptr: buffer\n");
		ret = ERR_BLAZEME_OK;
		goto out;
	}

	if (count > KBUF_LEN) {
		printk(KERN_INFO "blazeme_wrtie invaild paramter count (%zu)\n", count);
		ret = ERR_BLAZEME_OK;
		goto out;
	} 

	kbuf = NULL;
	kbuf = kmalloc(KBUF_LEN, GFP_KERNEL);
	if (kbuf == NULL) {
		printk(KERN_INFO "blazeme_write malloc fail\n");
		ret = ERR_BLAZEME_MALLOC_FAIL;
		goto out;
	}

	if (copy_from_user(kbuf, buf, count)) {
		kfree(kbuf);
		kbuf = NULL;
		goto out;
	}

	if (kbuf != NULL) {
		strncat(str, kbuf, strlen(kbuf));
		printk(KERN_INFO "%s", str);
	}

	return (ssize_t)count;

out:
	return ret;
}

int blazeme_open(struct inode *inode, struct file *file) {
	return 0;
}

int blazeme_close(struct inode *inode, struct file *file) {
	return 0;
}

int blazeme_init(void) {
	int ret = 0;

	ret = alloc_chrdev_region(&dev, 0, 1, DEVICE_NAME);
	if (ret) {
		printk("blazeme_init failed alloc: %d\n", ret);
		return ret;
	}

	memset(&cdev, 0, sizeof(struct cdev));
	
	cdev_init(&cdev, &blazeme_fops);
	cdev.owner = THIS_MODULE;
	cdev.ops = &blazeme_fops;

	ret = cdev_add(&cdev, dev, 1);
	if (ret) {
		printk("blazeme_init, cdev_add fail\n");
		return ret;
	}

	blazeme_class = class_create(THIS_MODULE, DEVICE_NAME);
	if (IS_ERR(blazeme_class)) {
		printk("blazeme_init, class create failed!\n");
		return ret;
	}

	dev = device_create(blazeme_class, NULL, dev, NULL, DEVICE_NAME);
	if (IS_ERR(&cdev)) {
		ret = PTR_ERR(&cdev);
		printk("blazeme_init device create failed\n"); 

		class_destroy(blazeme_class);
		cdev_del(&cdev);
		unregister_chrdev_region(&dev, 1);

		return ret;
	}

	return 0;
}

void blazeme_exit(void)
{
	cdev_del(&cdev);
	class_destroy(blazeme_class);
	unregister_chrdev_region(&dev, 1);
}

module_init(blazeme_init);
module_exit(blazeme_exit);
MODULE_LICENSE("GPL");
MODULE_AUTHOR("BLAZECTF 2018 crixer");
MODULE_DESCRIPTION("BLAZECTF CTF 2018 Challenge Kernel Module");


