# really simple, just a DFS over the fat32 filesystem.
# flag is in one of the nontrivial paths
# The idea was probably inspired by regex2fat which was trending recently.
# https://github.com/8051Enthusiast/regex2fat

# visit 444928 SPACESPACE!SPACE!SPACESPACESPACE!#PCPCPCTF{PCPCTF{PCTF{WHAT_IN_TARNATION_IS_TH1S_FILESYSTEM!}SPACESPACESPACE!SPACE&$$$%

import struct
import sys

def getBytes(fs, pos, numBytes):
  fs.seek(pos)
  byte = fs.read(numBytes)
  if (numBytes == 2):
    formatString = "H"
  elif (numBytes == 1):
    formatString = "B"
  elif (numBytes == 4):
    formatString = "i"
  else:
    raise Exception("Not implemented")
  return struct.unpack("<"+formatString, byte)[0]

def getString(fs, pos, numBytes):
  fs.seek(pos)
  raw = fs.read(numBytes)
  return struct.unpack(str(numBytes)+"s", raw)[0]

def bytesPerSector(fs):
  return getBytes(fs,11,2)

def sectorsPerCluster(fs):
  return getBytes(fs,13,1)

def reservedSectorCount(fs):
  return getBytes(fs,14,2)

def numberOfFATs(fs):
  return getBytes(fs,16,1)

def FATStart(fs, numFat):
  return reservedSectorCount(fs) * bytesPerSector(fs)

def FATSize(fs):
  return getBytes(fs, 36, 4)

def rootStart(fs):
  return FATStart(fs,1) + (FATSize(fs) * numberOfFATs(fs) * bytesPerSector(fs))

def clusterStart(fs, cluster):
  return rootStart(fs) + cluster * sectorsPerCluster(fs) * bytesPerSector(fs)

def fsIdentityString(fs):
  return getString(fs,82,8)

def getDirTableEntry(fs, offset):
  while True:
    if getBytes(fs, offset, 1) == 0:
      break
    fs.seek(offset + 0x0B)
    isLFN = (struct.unpack("b", fs.read(1))[0] == 0x0F)
    if isLFN:
      fileName = "SKIPPED"
    else:
      fs.seek(offset)
      fileName = struct.unpack("8s", fs.read(8))[0]
      highCluster = getBytes(fs, offset + 0x14, 2)
      lowCluster = getBytes(fs, offset + 0x1a, 2)
      cluster = lowCluster | (highCluster << 16)
    offset += 32
    yield (isLFN, fileName, cluster)

def ppNum(num):
  return "%s (%s)" % (hex(num), num)

fs = open('strcmp.fat32',"rb")
print "Bytes per sector:",        ppNum(bytesPerSector(fs))
print "Sectors per cluster:",     ppNum(sectorsPerCluster(fs))
print "Reserved sector count:",   ppNum(reservedSectorCount(fs))
print "Number of FATs:",          ppNum(numberOfFATs(fs))
print "Start of FAT1:",           ppNum(FATStart(fs, 1))
print "Start of root directory:", ppNum(rootStart(fs))
print "Identity string:",         fsIdentityString(fs)
print "Files & directories:"

visited = {}
def dfs(offset, path=''):
  if offset in visited:
    return
  print 'visit',offset, path.replace('/','')
  visited[offset] = path
  for lfn,name,child_cluster in getDirTableEntry(fs, offset):
    if lfn: continue # bad script
    name = name.rstrip()
    # print 'child',path + '/' + name,child_cluster
    child_cluster-=2 # two reserved clusters (BPB and EBPB)
    dfs(clusterStart(fs,child_cluster), path + '/' + name)

dfs(rootStart(fs))