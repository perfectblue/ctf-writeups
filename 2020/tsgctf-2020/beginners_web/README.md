# Beginners web

The trick here that we controlled `request.body.converter`, so we could do `__defineSetter__`` on `converters` with your sessionID as the first parameter, and the object which would then be resolved as a promise?? The next we set flagConverted on it with our sessionID, the promise gets resolved, some error gets printed and we get the flag. 
