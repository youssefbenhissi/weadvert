const sql = require("./db.js");

// constructor
const Voiture = function(Voiture) {
  this.idAuto = Voiture.idAuto;
  this.idVoiture = Voiture.idVoiture;
  this.type = Voiture.type;
  this.marque = Voiture.marque;
  this.model = Voiture.model;
  this.annee = Voiture.annee;
};

Voiture.create = (newVoiture, result) => {
  sql.query("INSERT INTO Voiture SET ?", newVoiture, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }

    console.log("created Voiture: ", { id: res.insertId, ...newVoiture });
    result(null, { id: res.insertId, ...newVoiture });
  });
};

Voiture.findById = (automobilisteId, result) => {
  sql.query(`SELECT * FROM Voiture V, Image I WHERE idAuto = ${automobilisteId} AND V.idVoiture = I.idVoiture`, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }

    if (res.length) {
      console.log("found Voiture: ", {res});
      result(null, res);
      return;
    }

    // not found Customer with the id
    result({ kind: "not_found" }, null);
  });
};

Voiture.getAll = result => {
  sql.query("SELECT * FROM Voiture", (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(null, err);
      return;
    }

    console.log("Voiture: ", res);
    result(null, res);
  });
};
Voiture.updateById = (idAuto, voiture, result) => {
  sql.query(
    "UPDATE Voiture SET type = ?, marque = ?, model = ?, annee = ? WHERE idAuto = ?",[voiture.type, voiture.marque, voiture.model,voiture.annee, 
      idAuto],
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

      console.log("updated Voiture: ", { idAuto: idAuto, ...Voiture });
      result(null, { idAuto: idAuto, ...Voiture });
    }
  );
};

Voiture.remove = (idVoiture, result) => {
  sql.query("DELETE FROM Voiture WHERE idAuto = ?", id, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(null, err);
      return;
    }

    if (res.affectedRows == 0) {
      result({ kind: "not_found" }, null);
      return;
    }

    console.log("deleted Voiture with id: ", id);
    result(null, res);
  });
};

Voiture.removeAll = result => {
  sql.query("DELETE FROM Voiture", (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(null, err);
      return;
    }

    console.log(`deleted ${res.affectedRows} Voiture`);
    result(null, res);
  });
};

module.exports = Voiture;