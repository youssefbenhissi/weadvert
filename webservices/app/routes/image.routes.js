module.exports = app => {
    const image = require("../controllers/image.controller.js");
  
    
    app.post("/image", image.create);
  
    app.get("/image", image.findAll);
  
    app.get("/image_voiture/:voitureId", image.findVoitureImages);

    app.get("/image_voiture_auto/:autoId", image.findAutoVoitureImages);
    
    app.put("/image/:imageId", image.update);

    app.delete("/image/:imageNom", image.delete);

    app.delete("/image", image.deleteAll);
    
  };