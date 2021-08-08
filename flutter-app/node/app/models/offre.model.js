const sql = require("./db.js");

// constructor
const Offre = function (offre) {
  this.idOffre = offre.idOffre;
  this.idAnnonceur = offre.idAnnonceur;
  this.description = offre.description;
  this.gouvernorat = offre.gouvernorat;
  this.delegation = offre.delegation;
  this.cible = offre.cible;
  this.dateDeb = offre.dateDeb;
  this.dateFin = offre.dateFin;
  this.renouvelable = offre.renouvelable;
  this.nbCandidats = offre.nbCandidats;
  this.cout = offre.cout;
};

Offre.create = (newOffre, result) => {
  sql.query("INSERT INTO Offre SET ?", newOffre, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }

    console.log("created Offre: ", { id: res.insertId, ...newOffre });
    result(null, { id: res.insertId, ...newOffre });
  });
};

Offre.approuverAutomobiliste = (offreId, autoId, result) => {
  sql.query("DELETE FROM candidature WHERE idAuto = ?", autoId, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(null, err);
      return;
    }

    if (res.affectedRows == 0) {
      result({ kind: "not_found" }, null);
      return;
    }

    //console.log("deleted offre with id: ", offreId);
    sql.query("Update offre set nbCandidats = nbCandidats - 1 WHERE idOffre = ?", [offreId], (err2, res2) => {
      if (err2) {
        console.log("error: ", err2);
        result(err1, null);
        return;
      }
    });

    sql.query("INSERT INTO revenu(idAuto, idOffre, solde) values (?,?,0.0)", [autoId, offreId], (err1, res1) => {
      if (err1) {
        console.log("error: ", err1);
        result(err1, null);
        return;
      }
      console.log("created Revenu: ", { idAuto: autoId, idOffre: offreId });
      result(null, { idAuto: autoId, idOffre: offreId });
    });
  });
};

Offre.declineAutomobiliste = (offreId, autoId, result) => {
  sql.query("DELETE FROM candidature WHERE idAuto = ? AND idOffre = ?", [autoId, offreId], (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(null, err);
      return;
    }

    if (res.affectedRows == 0) {
      result({ kind: "not_found" }, null);
      return;
    }

    console.log("deleted candidature with idAuto: ", autoId, "And idOffre: ", offreId);
    result(null, { idAuto: autoId, idOffre: offreId });
  });
};

Offre.findById = (offreId, result) => {
  sql.query(`SELECT * FROM offre WHERE idOffre = ${offreId}`, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }

    if (res.length) {
      console.log("found Offre: ", res[0]);
      result(null, res[0]);
      return;
    }
    result({ kind: "not_found" }, null);
  });
};


Offre.nbOffres = (annonceurId, result) => {
  sql.query(`SELECT COUNT(*) as nbOffres  FROM offre o WHERE o.idAnnonceur = ${annonceurId}`, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }

    if (res.length) {
      console.log("found Offre: ", res[0]);
      result(null, res[0]);
      return;
    }
    result({ kind: "not_found" }, null);
  });
};

Offre.nbUsers = (annonceurId, result) => {
  sql.query(`SELECT COUNT(*) as nbUsers  FROM offre o , revenu r WHERE o.idAnnonceur = ${annonceurId} 
    AND r.idOffre = o.idOffre`, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }

    if (res.length) {
      console.log("found Offre: ", res[0]);
      result(null, res[0]);
      return;
    }
    result({ kind: "not_found" }, null);
  });
};

Offre.findCurrentAutomobilistes = (annonceurId, result) => {
  sql.query(`SELECT * FROM annonceur an, offre o, automobiliste a, revenu r, users_location ul 
    WHERE an.idAnnonceur = o.idAnnonceur 
      AND o.idOffre = r.idOffre AND an.idAnnonceur = ${annonceurId}
        AND r.idAuto = ul.idAuto AND a.idAuto = r.idAuto`, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }

    if (res.length) {
      console.log("found Offre: ", res);
      result(null, res);
      return;
    }
    result(null, { kind: "not_found" });
  });
};

Offre.findCurrentOffer = (automobilisteId, result) => {
  sql.query(`SELECT * FROM revenu r, offre o, annonceur a WHERE r.idAuto = ${automobilisteId} 
    AND r.idOffre = o.idOffre AND o.dateFin > NOW() AND a.idAnnonceur = o.idAnnonceur`, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }

    if (res.length) {
      console.log("found Offre: ", res[0]);
      result(null, res[0]);
      return;
    }
    result({ kind: "not_found" }, null);
  });
};

Offre.findAutoSolde = (automobilisteId, result) => {
  sql.query(`SELECT solde FROM revenu WHERE idAuto = ${automobilisteId}`, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }

    if (res.length) {
      console.log("found Offre: ", res);
      result(null, res);
      return;
    }
    result({ kind: "not_found" }, null);
  });
};

Offre.totalCout = (annonceurId, result) => {
  sql.query(`SELECT SUM(cout) as totalCout FROM offre o WHERE o.idAnnonceur = ${annonceurId}`, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }

    if (res.length) {
      console.log("found Offre: ", res);
      result(null, res);
      return;
    }
    result({ kind: "not_found" }, null);
  });
};

Offre.getAll = result => {
  sql.query("SELECT * FROM offre o, annonceur a WHERE a.idAnnonceur = o.idAnnonceur AND o.dateFin > NOW()", (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(null, err);
      return;
    }

    console.log("Offre: ", { res });
    result(null, res);
  });
};

Offre.getAllByAnnonceur = (annonceurId, result) => {
  sql.query(`SELECT * FROM offre o, annonceur a WHERE a.idAnnonceur = o.idAnnonceur AND o.dateFin > NOW() AND a.idAnnonceur =  ${annonceurId}`, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(null, err);
      return;
    }

    console.log("Offre: ", { res });
    result(null, res);
  });
};

Offre.getAllCandidates = (annonceurId, result) => {
  sql.query("SELECT * FROM automobiliste a, candidature c, offre o, annonceur an, voiture v "
    + "WHERE v.idAuto = c.idAuto AND c.idAuto = a.idAuto AND c.idOffre = o.idOffre AND an.idAnnonceur = o.idAnnonceur AND o.dateFin > NOW() AND o.idAnnonceur = ? AND c.etatValidation = 0", [annonceurId],
    (err, res) => {
      if (err) {
        console.log("error: ", err);
        result(null, err);
        return;
      }

      console.log("Offre: ", { res });
      result(null, res);
    });
};

Offre.findOldOffers = (autoId, result) => {
  sql.query(`SELECT * FROM revenu r, offre o, annonceur a  WHERE r.idAuto = ${autoId} AND r.idOffre = o.idOffre 
  	AND o.idAnnonceur = a.idAnnonceur
  	AND o.dateFin < NOW() `, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }

    if (res.length) {
      console.log("found Offre: ", res);
      result(null, res);
      return;
    }
    result({ kind: "not_found" }, null);
  });
};

Offre.updateAutoSolde = (idAuto, montant, result) => {
  sql.query(
    "UPDATE revenu SET solde = solde + ? WHERE idAuto = ?", [montant, idAuto], (err, res) => {
      if (err) {
        console.log("error: ", err);
        result(null, err);
        return;
      }

      if (res.affectedRows == 0) {
        result({ kind: "not_found" }, null);
        return;
      }
      sql.query(
        "UPDATE automobiliste SET revenu = revenu + ? WHERE idAuto = ?", [montant, idAuto], (err, res) => {
          if (err) {
            console.log("error: ", err);
            result(null, err);
            return;
          }

          if (res.affectedRows == 0) {
            result({ kind: "not_found" }, null);
            return;
          }

          console.log("updated automobiliste revenu: ", { idAuto: idAuto });
        }
      );
      console.log("updated automobiliste solde: ", { idAuto: idAuto });
      result(null, { idAuto: idAuto });
    }

  );
};

Offre.updateById = (idOffre, Offre, result) => {
  sql.query(
    "UPDATE Offre SET description = ?, gouvernorat = ?, delegation = ?, cible = ?, dateDeb = ?, dateFin = ?, "
    + "renouvelable = ?, nbCandidats = ?, cout = ? WHERE idOffre = ?",

    [Offre.description, Offre.gouvernorat, Offre.delegation, Offre.cible, Offre.dateDeb, Offre.dateFin,
    Offre.renouvelable, Offre.nbCandidats, Offre.cout, idOffre],
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

      console.log("updated offre: ", { idAuto: idAuto, ...Offre });
      result(null, { idAuto: idOffre, ...Offre });
    }
  );
};

Offre.updateImageAnnonceur = (idAnnonceur, annonceur, result) => {
  sql.query(
    "UPDATE annonceur SET image = ? WHERE idAnnonceur = ?", [annonceur.image, idAnnonceur],
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

      console.log("updated annonceur: ", { idAnnonceur: idAnnonceur });
      result(null, { idAnnonceur: idAnnonceur });
    }
  );
};

Offre.remove = (idOffre, result) => {
  sql.query("DELETE FROM Offre WHERE idOffre = ?", idOffre, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(null, err);
      return;
    }

    if (res.affectedRows == 0) {
      result({ kind: "not_found" }, null);
      return;
    }

    console.log("deleted offre with id: ", idOffre);
    result(null, res);
  });
};

Offre.removeAll = result => {
  sql.query("DELETE FROM Offre", (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(null, err);
      return;
    }

    console.log(`deleted ${res.affectedRows} Offres`);
    result(null, res);
  });
};

module.exports = Offre;