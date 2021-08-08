const UserLocation = require("../models/users_location.model.js");

exports.create = (req, res) => {

  if (!req.body) {
    res.status(400).send({
      message: "Content can not be empty!"
    });
  }
  
  const userLocation = new UserLocation({
    idAuto: req.body.idAuto,
    latitude: req.body.latitude,
    longitude : req.body.longitude,
    inOnline : req.body.dateNaiss,
  });
  

  UserLocation.create(automobiliste, (err, data) => {
    if (err)
      res.status(500).send({
        message:
        err.message || "Some error occurred while creating the Automobiliste."
      });
    else res.send(data);
  });
};

exports.find = (req, res) => {
  UserLocation.findById(req.params.offreId, (err, data) => {
    if (err) {
      if (err.kind === "not_found") {
        res.status(404).send({
          message: `Not found users_location with idOffre ${req.params.offreId}.`
        });
      } else {
        res.status(500).send({
          message: "Error retrieving userLocation with idOffre " + req.params.offreId
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

  UserLocation.updateById(
    req.params.automobilisteId,
    new UserLocation(req.body),
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
