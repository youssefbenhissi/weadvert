const Voiture = require("../models/voiture.model.js");

exports.create = (req, res) => {
  
    if (!req.body) {
      res.status(400).send({
        message: "Content can not be empty!"
      });
    }
    const voiture = new Voiture({
      idAuto: req.body.idAuto,
      idVoiture: req.body.idVoiture,
      type : req.body.type,
      marque : req.body.marque,
      model : req.body.model,
      annee : req.body.annee,
    });
  
 
    Voiture.create(voiture, (err, data) => {
      if (err)
        res.status(500).send({
          message:
            err.message || "Some error occurred while creating the voiture."
        });
      else res.send(data);
    });
  };

exports.findAll = (req, res) => {
    Voiture.getAll((err, data) => {
      if (err)
        res.status(500).send({
          message:
            err.message || "Some error occurred while retrieving voiture."
        });
      else res.send(data);
    });
};

exports.findOne = (req, res) => {
    Voiture.findById(req.params.automobilisteId, (err, data) => {
      if (err) {
        if (err.kind === "not_found") {
          res.status(404).send({
            message: `Not found voiture with id ${req.params.automobilisteId}.`
          });
        } else {
          res.status(500).send({
            message: "Error retrieving mmebre with idvoiture " + req.params.automobilisteId
          });
        }
      } else res.send(data);
    });
};

exports.update = (req, res) => {
    if (!req.body) {
      res.status(400).send({
        message: "Content can not be empty!"
      });
    }
  
  Voiture.updateById(
    req.params.automobilisteId,
    new Voiture(req.body),
      (err, data) => {
        if (err) {
          if (err.kind === "not_found") {
            res.status(404).send({
              message: `Not found voiture with id ${req.params.automobilisteId}.`
            });
          } else {
            res.status(500).send({
              message: "Error updating voiture with id " + req.params.automobilisteId
            });
          }
        } else res.send(data);
      }
    );
  };

exports.delete = (req, res) => {
    Voiture.remove(req.params.voitureId, (err, data) => {
      if (err) {
        if (err.kind === "not_found") {
          res.status(404).send({
            message: `Not found voiture with id ${req.params.voitureId}.`
          });
        } else {
          res.status(500).send({
            message: "Could not delete voiture with id " + req.params.voitureId
          });
        }
      } else res.send({ message: `voiture was deleted successfully!` });
    });
};

exports.deleteAll = (req, res) => {
    Voiture.removeAll((err, data) => {
      if (err)
        res.status(500).send({
          message:
            err.message || "Some error occurred while removing all voitures."
        });
      else res.send({ message: `All voitures were deleted successfully!` });
    });
};