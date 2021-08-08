const Automobiliste = require("../models/automobiliste.model.js");

exports.create = (req, res) => {
  
    if (!req.body) {
      res.status(400).send({
        message: "Content can not be empty!"
      });
    }
  
    // Create an Automobiliste
    const automobiliste = new Automobiliste({
      idAuto: req.body.idAuto,
      nom: req.body.nom,
      prenom : req.body.prenom,
      dateNaiss : req.body.dateNaiss,
      email : req.body.email,
      cin : req.body.cin,
      photo : req.body.photo,
      profession : req.body.profession,
      lieuCirculation : req.body.lieuCirculation,
      revenu : req.body.revenu,
      score : req.body.score,
      numerotelephone : req.body.numerotelephone,
    });
  
 
    Automobiliste.create(automobiliste, (err, data) => {
      if (err)
        res.status(500).send({
          message:
            err.message || "Some error occurred while creating the Automobiliste."
        });
      else res.send(data);
    });
  };
  exports.findAll = (req, res) => {
    Automobiliste.getAll((err, data) => {
      if (err)
        res.status(500).send({
          message:
            err.message || "Some error occurred while retrieving Automobiliste."
        });
      else res.send(data);
    });
  };
  exports.findOne = (req, res) => {
    Automobiliste.findById(req.params.automobilisteId, (err, data) => {
      if (err) {
        if (err.kind === "not_found") {
          res.status(404).send({
            message: `Not found Automobiliste with id ${req.params.automobilisteId}.`
          });
        } else {
          res.status(500).send({
            message: "Error retrieving mmebre with idAutomobiliste " + req.params.automobilisteId
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
  
    Automobiliste.updateById(
      req.params.automobilisteId,
      new Automobiliste(req.body),
      (err, data) => {
        if (err) {
          if (err.kind === "not_found") {
            res.status(404).send({
              message: `Not found Automobiliste with id ${req.params.automobilisteId}.`
            });
          } else {
            res.status(500).send({
              message: "Error updating Automobiliste with id " + req.params.automobilisteId
            });
          }
        } else res.send(data);
      }
    );
  };
  exports.delete = (req, res) => {
    Automobiliste.remove(req.params.automobilisteId, (err, data) => {
      if (err) {
        if (err.kind === "not_found") {
          res.status(404).send({
            message: `Not found Automobiliste with id ${req.params.automobilisteId}.`
          });
        } else {
          res.status(500).send({
            message: "Could not delete Automobiliste with id " + req.params.automobilisteId
          });
        }
      } else res.send({ message: `Automobiliste was deleted successfully!` });
    });
  };
  exports.deleteAll = (req, res) => {
    Automobiliste.removeAll((err, data) => {
      if (err)
        res.status(500).send({
          message:
            err.message || "Some error occurred while removing all Automobilistes."
        });
      else res.send({ message: `All Automobilistes were deleted successfully!` });
    });
  };