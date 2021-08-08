module.exports = app => {
    const offre = require("../controllers/offre.controller.js");
  
    
    app.post("/offre", offre.create);

    app.post("/approuverAutomobiliste/:offreId/:autoId", offre.approuverAutomobiliste);
  
    app.get("/offre", offre.findAll);
    
    app.get("/offre/:annonceurId", offre.findAllByAnnonceur);
  
    app.get("/offre/:offreId", offre.findOne);

    app.get("/oldOffres/:autoId", offre.findOldOffers);

    app.get("/offreAutos/:annonceurId", offre.findCurrentAutomobilistes);

    app.get("/nbOffres/:annonceurId", offre.nbOffres);

    app.get("/nbUsers/:annonceurId", offre.nbUsers);

    app.get("/currentOffer/:automobilisteId", offre.findCurrentOffer);

    app.get("/autoSolde/:automobilisteId", offre.findAutoSolde);

    app.get("/totalCout/:annonceurId", offre.totalCout);

    app.get("/allCandidates/:annonceurId", offre.findAllCandidates);
    
    app.put("/offre/:offreId", offre.update);

    app.put("/updateAutoSolde/:autoId/:montant", offre.updateAutoSolde);

    app.put("/updateImageAnnonceur/:annonceurId", offre.updateImageAnnonceur);

    app.delete("/offre/:offreId", offre.delete);

    app.delete("/declineAutomobiliste/:offreId/:autoId", offre.declineAutomobiliste);

    app.delete("/offre", offre.deleteAll);
    
  };