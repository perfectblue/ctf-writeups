#define PKID( a, b ) (((b)<<24)|((a)<<16)|('K'<<8)|'P')

struct ZIP_EndOfCentralDirRecord
{
	DECLARE_BYTESWAP_DATADESC();
	unsigned int	signature; // 4 bytes PK56
	unsigned short	numberOfThisDisk;  // 2 bytes
	unsigned short	numberOfTheDiskWithStartOfCentralDirectory; // 2 bytes
	unsigned short	nCentralDirectoryEntries_ThisDisk;	// 2 bytes
	unsigned short	nCentralDirectoryEntries_Total;	// 2 bytes
	unsigned int	centralDirectorySize; // 4 bytes
	unsigned int	startOfCentralDirOffset; // 4 bytes
	unsigned short	commentLength; // 2 bytes
	// zip file comment follows
};

struct ZIP_FileHeader
{
	DECLARE_BYTESWAP_DATADESC();
	unsigned int	signature; //  4 bytes PK12 
	unsigned short	versionMadeBy; // version made by 2 bytes 
	unsigned short	versionNeededToExtract; // version needed to extract 2 bytes 
	unsigned short	flags; // general purpose bit flag 2 bytes 
	unsigned short	compressionMethod; // compression method 2 bytes 
	unsigned short	lastModifiedTime; // last mod file time 2 bytes 
	unsigned short	lastModifiedDate; // last mod file date 2 bytes 
	unsigned int	crc32; // crc-32 4 bytes 
	unsigned int	compressedSize; // compressed size 4 bytes 
	unsigned int	uncompressedSize; // uncompressed size 4 bytes 
	unsigned short	fileNameLength; // file name length 2 bytes 
	unsigned short	extraFieldLength; // extra field length 2 bytes 
	unsigned short	fileCommentLength; // file comment length 2 bytes 
	unsigned short	diskNumberStart; // disk number start 2 bytes 
	unsigned short	internalFileAttribs; // internal file attributes 2 bytes 
	unsigned int	externalFileAttribs; // external file attributes 4 bytes 
	unsigned int	relativeOffsetOfLocalHeader; // relative offset of local header 4 bytes 
	// file name (variable size) 
	// extra field (variable size) 
	// file comment (variable size) 
};

struct ZIP_LocalFileHeader
{
	DECLARE_BYTESWAP_DATADESC();
	unsigned int	signature; //local file header signature 4 bytes PK34 
	unsigned short	versionNeededToExtract; // version needed to extract 2 bytes 
	unsigned short	flags; // general purpose bit flag 2 bytes 
	unsigned short	compressionMethod; // compression method 2 bytes 
	unsigned short	lastModifiedTime; // last mod file time 2 bytes 
	unsigned short	lastModifiedDate; // last mod file date 2 bytes 
	unsigned int	crc32; // crc-32 4 bytes 
	unsigned int	compressedSize; // compressed size 4 bytes 
	unsigned int	uncompressedSize; // uncompressed size 4 bytes 
	unsigned short	fileNameLength; // file name length 2 bytes 
	unsigned short	extraFieldLength; // extra field length 2 bytes 
	// file name (variable size) 
	// extra field (variable size) 
};
