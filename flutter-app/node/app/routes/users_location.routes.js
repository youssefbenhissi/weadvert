module.exports = app => {
    const userLocation = require("../controllers/users_location.controller.js");
  
  
    app.get("/userLocation/:offreId", userLocation.find);
    
    app.put("/userLocation/:automobilisteId", userLocation.update);

    app.delete("/userLocation/:automobilisteId", userLocation.delete);   
  };