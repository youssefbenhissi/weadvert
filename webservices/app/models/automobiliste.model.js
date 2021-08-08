const sql = require("../../index.js");

// constructor
const Automobiliste = function(Automobiliste) {
  this.idAuto = Automobiliste.idAuto;
  this.nom = Automobiliste.nom;
  this.prenom = Automobiliste.prenom;
  this.dateNaiss = Automobiliste.dateNaiss;
  this.email = Automobiliste.email;
  this.cin = Automobiliste.cin;
  this.photo = Automobiliste.photo;
  this.profession = Automobiliste.profession;
  this.lieuCirculation = Automobiliste.lieuCirculation;
  this.revenu = Automobiliste.revenu;
  this.score = Automobiliste.score;
  this.numerotelephone = Automobiliste.numerotelephone
};

Automobiliste.create = (newAutomobiliste, result) => {
  sql.query("INSERT INTO automobiliste SET ?", newAutomobiliste, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }

    console.log("created Automobiliste: ", { id: res.insertId, ...newAutomobiliste });
    result(null, { id: res.insertId, ...newAutomobiliste });
  });
};

Automobiliste.findById = (AutomobilisteId, result) => {
  sql.query(`SELECT * FROM automobiliste WHERE idAuto = ${AutomobilisteId}`, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }

    if (res.length) {
      console.log("found Automobiliste: ", res[0]);
      result(null, res[0]);
      return;
    }

    // not found Customer with the id
    result({ kind: "not_found" }, null);
  });
};

Automobiliste.getAll = result => {
  sql.query("SELECT * FROM automobiliste", (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(null, err);
      return;
    }

    console.log("Automobiliste: ", res);
    result(null, res);
  });
};
Automobiliste.updateById = (idAuto, Automobiliste, result) => {
  sql.query(
    "UPDATE automobiliste SET nom = ?, prenom = ?, dateNaiss = ?, cin = ?, photo = ?, profession = ?, "
    +"lieuCirculation = ? WHERE idAuto = ?",

    [Automobiliste.nom, Automobiliste.prenom, Automobiliste.dateNaiss, Automobiliste.cin, 
      Automobiliste.photo, Automobiliste.profession, Automobiliste.lieuCirculation, idAuto],
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

      console.log("updated automobiliste: ", { idAuto: idAuto, ...Automobiliste });
      result(null, { idAuto: idAuto, ...Automobiliste });
    }
  );
};

Automobiliste.remove = (id, result) => {
  sql.query("DELETE FROM automobiliste WHERE idAuto = ?", id, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(null, err);
      return;
    }

    if (res.affectedRows == 0) {
      result({ kind: "not_found" }, null);
      return;
    }

    console.log("deleted automobiliste with id: ", id);
    result(null, res);
  });
};

Automobiliste.removeAll = result => {
  sql.query("DELETE FROM automobiliste", (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(null, err);
      return;
    }

    console.log(`deleted ${res.affectedRows} Automobiliste`);
    result(null, res);
  });
};

module.exports = Automobiliste;