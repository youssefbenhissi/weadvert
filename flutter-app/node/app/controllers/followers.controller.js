const Followers = require("../models/followers.model.js");

exports.create = (req, res) => {
  
    if (!req.body) {
      res.status(400).send({
        message: "Content can not be empty!"
      });
    }
  
    // Create an Offre
    const followers = new Followers({
      idAuto : req.body.idAuto,
      idAnnonceur : req.body.idAnnonceur,
      token : req.body.token,
    });
  
 
    Followers.create(followers, (err, data) => {
      if (err)
        res.status(500).send({
          message:
            err.message || "Some error occurred while creating the Offre."
        });
      else res.send(data);
    });
};

exports.isFollowing = (req, res) => {
    Followers.isFollowing(req.params.autoId, req.params.annonceurId, (err, data) => {
      if (err) {
        if (err.kind === "not_found") {
          res.status(404).send({
            message: `Not found Followers with idAuto ${req.params.autoId} AND idAnnonceur ${req.params.annonceurId}.`
          });
        } else {
          res.status(500).send({
            message: "Error retrieving mmebre with idAnnonceur " + req.params.annonceurId + " And idAuto " + req.params.autoId
          });
        }
      } else res.send(data);
    });
};

exports.getFollowers = (req, res) => {
    Followers.getFollowers(req.params.annonceurId, (err, data) => {
      if (err) {
        if (err.kind === "not_found") {
          res.status(404).send({
            message: `Not found Followers with idAnnonceur ${req.params.annonceurId}.`
          });
        } else {
          res.status(500).send({
            message: "Error retrieving mmebre with idAnnonceur " + req.params.annonceurId
          });
        }
      } else res.send(data);
    });
};

exports.getToken = (req, res) => {
    Followers.getToken(req.params.autoId, (err, data) => {
      if (err) {
        if (err.kind === "not_found") {
          res.status(404).send({
            message: `Not found Followers with idAuto ${req.params.autoId}.`
          });
        } else {
          res.status(500).send({
            message: "Error retrieving mmebre with idAuto " + req.params.autoId
          });
        }
      } else res.send(data);
    });
};

exports.delete = (req, res) => {
    Followers.remove(req.params.autoId, req.params.annonceurId, (err, data) => {
      if (err) {
        if (err.kind === "not_found") {
          res.status(404).send({
            message: `Not found followers with idAnnonceur ${req.params.annonceurId} AND idAuto ${req.params.autoId}.`
          });
        } else {
          res.status(500).send({
            message: "Could not delete followers with id " + req.params.annonceurId + " And idAuto " + req.params.autoId
          });
        }
      } else res.send({ message: `Followers was deleted successfully!` });
    });
};
