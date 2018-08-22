class CStringData
{
public:
	DWORD m_Length; // Length of the string (not including terminator)
	DWORD m_BufferSize; // Length of the buffer
	LPSTR data() { return (LPSTR)(this + 1); }
};

class ATL_string_manager {
public:
   static ATL_string_manager the_Manager;
protected:
   class CNilStringData : public CStringData {
      long buffer32;  // 32 bits of zeros.  That's what MFC has.
   public:
      CNilStringData()
         {
         manager= &the_Manager;
         nRefs= 2;  // Never gets freed.
         nDataLength= nAllocLength= 0;
         buffer32= 0;
         }
      };
   CNilStringData m_nil;
public:
   virtual CStringData* Allocate( int nChars, int nCharSize );
   virtual void Free( CStringData* pData )  { free ((void*)pData); }
   virtual CStringData* Reallocate( CStringData* pData, int nChars, int nCharSize );
   virtual CStringData* GetNilString()  { ++m_nil.nRefs;  return &m_nil; }
   virtual ATL_string_manager* Clone()  { return this; }
};
