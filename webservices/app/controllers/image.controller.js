const Image = require("../models/image.model.js");


exports.create = (req, res) => {
    // Validate request
    if (!req.body) {
      res.status(400).send({
        message: "Content can not be empty!"
      });
    }
  
    
    const image = new Image({
      idImage: req.body.idImage,
      idVoiture: req.body.idVoiture,
      nom: req.body.nom
     });
  
    // Save group in the database
    Image.create(image, (err, data) => {
      if (err)
        res.status(500).send({
          message:
            err.message || "Some error occurred while creating the image."
        });
      else res.send(data);
    });
};

exports.findAll = (req, res) => {
    Image.getAll((err, data) => {
      if (err)
        res.status(500).send({
          message:
            err.message || "Some error occurred while retrieving images."
        });
      else res.send(data);
    });
};

exports.findVoitureImages = (req, res) => {
    Image.findVoitureImages(req.params.voitureId, (err, data) => {
      if (err) {
        if (err.kind === "not_found") {
          res.status(404).send({
            message: `Not found voiture images with id ${req.params.voitureId}.`
          });
        } else {
          res.status(500).send({
            message: "Error retrieving voiture images with imageId " + req.params.voitureId
          });
        }
      } else res.send(data);
    });
};

exports.findAutoVoitureImages = (req, res) => {
    Image.findAutoVoitureImages(req.params.autoId, (err, data) => {
      if (err) {
        if (err.kind === "not_found") {
          res.status(404).send({
            message: `Not found voiture images with id ${req.params.autoId}.`
          });
        } else {
          res.status(500).send({
            message: "Error retrieving voiture images with imageId " + req.params.autoId
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
  
    Image.updateById(
      req.params.imageId,
      new Image(req.body),
      (err, data) => {
        if (err) {
          if (err.kind === "not_found") {
            res.status(404).send({
              message: `Not found image with id ${req.params.imageId}.`
            });
          } else {
            res.status(500).send({
              message: "Error updating image with imageId " + req.params.imageId
            });
          }
        } else res.send(data);
      }
    );
};

exports.delete = (req, res) => {
    Image.remove(req.params.imageNom, (err, data) => {
      if (err) {
        if (err.kind === "not_found") {
          res.status(404).send({
            message: `Not found image with id ${req.params.imageNom}.`
          });
        } else {
          res.status(500).send({
            message: "Could not delete image with imageNom " + req.params.imageNom
          });
        }
      } else res.send({ message: `Image was deleted successfully!` });
    });
};

exports.deleteAll = (req, res) => {
    Image.removeAll((err, data) => {
      if (err)
        res.status(500).send({
          message:
            err.message || "Some error occurred while removing all images."
        });
      else res.send({ message: `All images were deleted successfully!` });
    });
};