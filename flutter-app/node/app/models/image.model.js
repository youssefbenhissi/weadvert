const sql = require("./db.js");


const Image = function(image) {
  this.idImage = image.idImage;
  this.idVoiture = image.idVoiture;
  this.nom = image.nom;
 };

Image.create = (newImage, result) => {
  sql.query("INSERT INTO image SET ?", newImage, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }

    console.log("created image: ", { id: res.insertIdImage, ...newImage });
    result(null, { id: res.insertIdImage, ...newImage });
  });
};

Image.findVoitureImages = (voitureId, result) => {
  sql.query(`SELECT * FROM image WHERE idVoiture = ${voitureId}`, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }

    if (res.length) {
      console.log("found images: ", {res});
      result(null, {res});
      return;
    }

    
    result(null, { res: "not_found" });
  });
};

Image.findAutoVoitureImages = (autoId, result) => {
  sql.query(`SELECT i.nom FROM image i , voiture v, automobiliste a WHERE a.idAuto = ${autoId} AND i.idVoiture = v.idVoiture
    AND v.idAuto = a.idAuto`, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }

    if (res.length) {
      console.log("found images: ", res);
      result(null, res);
      return;
    }  
    result(null, { res: "not_found" });
  });
};

Image.getAll = result => {
  sql.query("SELECT * FROM image", (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(null, err);
      return;
    }

    console.log("Image: ", res);
    result(null, res);
  });
};

Image.updateById = (idImage, image, result) => {
  sql.query(
    "UPDATE image SET imgName = ?, validation= ?, nbValidation = ? WHERE idImage = ?",
    [image.imgName, image.validation, image.nbValidation, idImage],
    (err, res) => {
      if (err) {
        console.log("error: ", err);
        result(null, err);
        return;
      }

      if (res.affectedRows == 0) {
        
        result({ kind: "not_found" }, null);
        return;
      }

      console.log("updated image: ", { idImage: idImage, ...image });
      result(null, { idImage: idImage, ...image });
    }
  );
};

Image.remove = (nomImage, result) => {
  sql.query("DELETE FROM image WHERE nom = ?", nomImage, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(null, err);
      return;
    }

    if (res.affectedRows == 0) {
      
      result({ kind: "not_found" }, null);
      return;
    }

    console.log("deleted image with nom: ", nomImage);
    result(null, res);
  });
};

Image.removeAll = result => {
  sql.query("DELETE FROM image", (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(null, err);
      return;
    }

    console.log(`deleted ${res.affectedRows} images`);
    result(null, res);
  });
};

module.exports = Image;