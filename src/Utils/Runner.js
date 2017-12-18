exports["showUI'"] = function(sc) {
    return function (screen) {
      return function() {
        var screenJSON = JSON.parse(screen);
        var screenName = screenJSON.tag;
        screenJSON.screen = screenName;
        window.showScreen(sc, screenJSON);
      }
    }
};

var callAPIImpl = function(success, err, method, url) {
    fetch(url, {mode : 'cors'})
    .then(function(res) {
      if(res.ok == false) {
        return Promise.reject(res)
        throw new Error("Failed to Fetch from URL");
      } else {
        return res.text()
      }
    })
    .then(function(resp){
        success(JSON.stringify(resp))();
    }).catch(function(err){
      console.log(err);
      success(JSON.stringify({ code: err.status,
                               status: err.statusText,
                               response: { error: true,
                                           userMessage: 'Request Failed',
                                           errorMessage: err.statusText
                                         }
                             })
             )();
    })
};

exports["callAPI'"] = function(error) {
  return function(success) {
    return function(request) {
        return function() {
            callAPIImpl(success, error, request.method, request.url);
        };
    };
  };
};
