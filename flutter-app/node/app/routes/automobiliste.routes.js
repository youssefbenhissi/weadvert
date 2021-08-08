module.exports = app => {
    const automobiliste = require("../controllers/automobiliste.controller.js");
  
    
    app.post("/automobiliste", automobiliste.create);
  
    app.get("/automobiliste", automobiliste.findAll);
  
    app.get("/automobiliste/:automobilisteId", automobiliste.findOne);
    
    app.put("/automobiliste/:automobilisteId", automobiliste.update);

    app.delete("/automobiliste/:automobilisteId", automobiliste.delete);

    app.delete("/automobiliste", automobiliste.deleteAll);
    
  };