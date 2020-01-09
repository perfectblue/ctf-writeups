req = indexedDB.open('/data', 21);
req.onsuccess = function(event) { 
	var db = event.target.result;
	console.log("Got db successfully")
	req2 = db.transaction('FILE_DATA', 'readonly').objectStore('FILE_DATA').get('/data/slot0.save')
	req2.onsuccess = function(event) {
		console.log(btoa(String.fromCharCode.apply(null, event.target.result.contents)))
	}
}