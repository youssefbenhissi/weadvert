module.exports = app => {
    const voiture = require("../controllers/voiture.controller.js");
  
    
    app.post("/voiture", voiture.create);
  
    app.get("/voiture", voiture.findAll);
  
    app.get("/voiture/:automobilisteId", voiture.findOne);
    
    app.put("/voiture/:automobilisteId", voiture.update);

    app.delete("/voiture/:voitureId", voiture.delete);

    app.delete("/voiture", voiture.deleteAll);
    
  };