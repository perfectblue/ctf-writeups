importData = "/0BvTVVpi7YLWmLez7B3a4nEy3a7qn4C7HBACRhmhpYlcmQPAOvmdPDfpvST5mY3fePGS0zC++jLTmoLmKLOH74U0NI6u8MKjD33bzeeFZ5oTGTFNmg1Z+3xvkoaz0Qe8G4Mki/y0ToWpxh4hhyhVJHErrzd4ItMzlvw+Yz1zQ6mQNoLDwOukBqOyuGfOjdCqonQv45lGSBOY333oMCvdEBuXd4NX2/pbgNT4h6N9d5ISFdCbXG9qIzpNOagQeQBYHA9Je97REUjTgaY/OjNTnHS/zY28zGOwQXL/wPsDnNvn97SoYlcwQ=="

req = indexedDB.open('/data', 21);
req.onsuccess = function(event) { 
	var db = event.target.result;
	console.log("Got db successfully")
	objectStore = db.transaction('FILE_DATA', 'readwrite').objectStore('FILE_DATA')
	req2 = objectStore.get('/data/slot0.save')
    var saveData;
	req2.onsuccess = function(event) {
		savedata = event.target.result
		savedata.contents = new Uint8Array(atob(importData).split('').map(function (c) { return c.charCodeAt(0); }));
		console.log("Got current savedata successfully")
		req3 = objectStore.put(savedata, '/data/slot1.save');
		req3.onsuccess = function(event) {
			console.log("Loaded " + (savedata.contents.length) + " bytes of savedata")
        }
	}
}