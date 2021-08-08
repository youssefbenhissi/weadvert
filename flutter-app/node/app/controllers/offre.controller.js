const Offre = require("../models/offre.model.js");

exports.create = (req, res) => {
  
    if (!req.body) {
      res.status(400).send({
        message: "Content can not be empty!"
      });
    }
  
    // Create an Offre
    const offre = new Offre({
      idOffre : req.body.idOffre,
      idAnnonceur : req.body.idAnnonceur,
      description : req.body.description,
      gouvernorat : req.body.gouvernorat,
      delegation : req.body.delegation,
      cible : req.body.cible,
      dateDeb : req.body.dateDeb,
      dateFin : req.body.dateFin,
      renouvelable : req.body.renouvelable,
      nbCandidats : req.body.nbCandidats,
      cout : req.body.cout,
    });
  
 
    Offre.create(offre, (err, data) => {
      if (err)
        res.status(500).send({
          message:
            err.message || "Some error occurred while creating the Offre."
        });
      else res.send(data);
    });
};

exports.findAll = (req, res) => {
    Offre.getAll((err, data) => {
      if (err)
        res.status(500).send({
          message:
            err.message || "Some error occurred while retrieving Offre."
        });
      else res.send(data);
    });
};

exports.findAllByAnnonceur = (req, res) => {
  Offre.getAllByAnnonceur(req.params.annonceurId, (err, data) => {
    if (err)
      res.status(500).send({
        message:
          err.message || "Some error occurred while retrieving Offre."
      });
    else res.send(data);
  });
};

exports.approuverAutomobiliste = (req, res) => {
    Offre.approuverAutomobiliste(req.params.offreId, req.params.autoId, (err, data) => {
      if (err)
        res.status(500).send({
          message:
            err.message || "Some error occurred while creating Revenu."
        });
      else res.send(data);
    });
};

exports.declineAutomobiliste = (req, res) => {
    Offre.declineAutomobiliste(req.params.offreId, req.params.autoId, (err, data) => {
      if (err)
        res.status(500).send({
          message:
            err.message || "Some error occurred while creating Revenu."
        });
      else res.send(data);
    });
};

exports.findAllCandidates = (req, res) => {
    Offre.getAllCandidates(req.params.annonceurId, (err, data) => {
      if (err)
        res.status(500).send({
          message:
            err.message || "Some error occurred while retrieving Offre."
        });
      else res.send(data);
    });
  };

exports.findOne = (req, res) => {
    Offre.findById(req.params.offreId, (err, data) => {
      if (err) {
        if (err.kind === "not_found") {
          res.status(404).send({
            message: `Not found Offre with id ${req.params.offreId}.`
          });
        } else {
          res.status(500).send({
            message: "Error retrieving mmebre with idOffre " + req.params.offreId
          });
        }
      } else res.send(data);
    });
};

exports.findOldOffers = (req, res) => {
    Offre.findOldOffers(req.params.autoId, (err, data) => {
      if (err) {
        if (err.kind === "not_found") {
          res.status(404).send({
            message: `Not found Auto with id ${req.params.autoId}.`
          });
        } else {
          res.status(500).send({
            message: "Error retrieving mmebre with idAuto " + req.params.autoId
          });
        }
      } else res.send(data);
    });
};

exports.findCurrentAutomobilistes = (req, res) => {
    Offre.findCurrentAutomobilistes(req.params.annonceurId, (err, data) => {
      if (err) {
        if (err.kind === "not_found") {
          res.status(404).send({
            message: `Not found Offre with id ${req.params.annonceurId}.`
          });
        } else {
          res.status(500).send({
            message: "Error retrieving offre with idOffre " + req.params.annonceurId
          });
        }
      } else res.send(data);
    });
};

exports.nbOffres = (req, res) => {
    Offre.nbOffres(req.params.annonceurId, (err, data) => {
      if (err) {
        if (err.kind === "not_found") {
          res.status(404).send({
            message: `Not found Offre with id ${req.params.annonceurId}.`
          });
        } else {
          res.status(500).send({
            message: "Error retrieving offre with idOffre " + req.params.annonceurId
          });
        }
      } else res.send(data);
    });
};

exports.nbUsers = (req, res) => {
    Offre.nbUsers(req.params.annonceurId, (err, data) => {
      if (err) {
        if (err.kind === "not_found") {
          res.status(404).send({
            message: `Not found Offre with id ${req.params.annonceurId}.`
          });
        } else {
          res.status(500).send({
            message: "Error retrieving offre with idOffre " + req.params.annonceurId
          });
        }
      } else res.send(data);
    });
};

exports.findCurrentOffer = (req, res) => {
    Offre.findCurrentOffer(req.params.automobilisteId, (err, data) => {
      if (err) {
        if (err.kind === "not_found") {
          res.status(404).send({
            message: `Not found Offre with id ${req.params.automobilisteId}.`
          });
        } else {
          res.status(500).send({
            message: "Error retrieving offre with idOffre " + req.params.automobilisteId
          });
        }
      } else res.send(data);
    });
};

exports.findAutoSolde = (req, res) => {
    Offre.findAutoSolde(req.params.automobilisteId, (err, data) => {
      if (err) {
        if (err.kind === "not_found") {
          res.status(404).send({
            message: `Not found Offre with id ${req.params.automobilisteId}.`
          });
        } else {
          res.status(500).send({
            message: "Error retrieving offre with idOffre " + req.params.automobilisteId
          });
        }
      } else res.send(data);
    });
};

exports.totalCout = (req, res) => {
    Offre.totalCout(req.params.annonceurId, (err, data) => {
      if (err) {
        if (err.kind === "not_found") {
          res.status(404).send({
            message: `Not found Offre with id ${req.params.annonceurId}.`
          });
        } else {
          res.status(500).send({
            message: "Error retrieving offre with idOffre " + req.params.annonceurId
          });
        }
      } else res.send(data);
    });
};

exports.update = (req, res) => {
    // Validate Request
    if (!req.body) {
      res.status(400).send({
        message: "Content can not be empty!"
      });
    }
  
    Offre.updateById(
      req.params.offreId,
      new Offre(req.body),
      (err, data) => {
        if (err) {
          if (err.kind === "not_found") {
            res.status(404).send({
              message: `Not found Offre with id ${req.params.offreId}.`
            });
          } else {
            res.status(500).send({
              message: "Error updating Offre with id " + req.params.offreId
            });
          }
        } else res.send(data);
      }
    );
};

exports.updateAutoSolde = (req, res) => {
  Offre.updateAutoSolde(
    req.params.autoId,
      req.params.montant,
      (err, data) => {
        if (err) {
          if (err.kind === "not_found") {
            res.status(404).send({
              message: `Not found idAuto with id ${req.params.autoId}.`
            });
          } else {
            res.status(500).send({
              message: "Error updating Offre with id " + req.params.autoId
            });
          }
      } else res.send(data);
    }
  );
};

exports.updateImageAnnonceur = (req, res) => {
  if (!req.body) {
    res.status(400).send({
      message: "Content can not be empty!"
    });
  }

  Offre.updateImageAnnonceur(req.params.annonceurId, req.body, 
    (err, data) => {
      if (err) {
        if (err.kind === "not_found") {
          res.status(404).send({
            message: `Not found Annonceur with id ${req.params.annonceurId}.`
          });
        } else {
          res.status(500).send({
            message: "Error updating Annonceur with id " + req.params.annonceurId
          });
        }
      } else res.send(data);
    }
  );
};

exports.delete = (req, res) => {
    Offre.remove(req.params.offreId, (err, data) => {
      if (err) {
        if (err.kind === "not_found") {
          res.status(404).send({
            message: `Not found Offre with id ${req.params.offreId}.`
          });
        } else {
          res.status(500).send({
            message: "Could not delete Offre with id " + req.params.offreId
          });
        }
      } else res.send({ message: `Offre was deleted successfully!` });
    });
};

exports.deleteAll = (req, res) => {
    Offre.removeAll((err, data) => {
      if (err)
        res.status(500).send({
          message:
            err.message || "Some error occurred while removing all Offres."
        });
      else res.send({ message: `All Offres were deleted successfully!` });
    });
};