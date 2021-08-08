const sql = require("./db.js");

// constructor
const Followers = function(offre) {
  this.idAuto = offre.idAuto;
  this.idAnnonceur = offre.idAnnonceur;
  this.token = offre.token
};

Followers.create = (newFollower, result) => {
  sql.query("INSERT INTO Followers SET ?", newFollower, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }

    console.log("created Followers: ", { id: res.insertId, ...newFollower });
    result(null, { id: res.insertId, ...newFollower });
  });
};

Followers.isFollowing = (autoId, annonceurId, result) => {
  sql.query(`SELECT COUNT(*) as isFollowing FROM Followers WHERE idAnnonceur = ${annonceurId} AND idAuto = ${autoId}`, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }

    if (res.length) {
      console.log("found Followers: ", res);
      result(null, res);
      return;
    }
    result({ kind: "not_found" }, null);
  });
};

Followers.getFollowers = (annonceurId, result) => {
  sql.query(`SELECT token FROM Followers WHERE idAnnonceur = ${annonceurId}`, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }

    if (res.length) {
      console.log("found Followers: ", res);
      result(null, res);
      return;
    }
    result({ kind: "not_found" }, null);
  });
};

Followers.getToken = (autoId, result) => {
  sql.query(`SELECT token FROM Followers WHERE idAuto = ${autoId}`, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }

    if (res.length) {
      console.log("found token: ", res);
      result(null, res);
      return;
    }
    result(null,{ kind: "not_found" });
  });
};

Followers.remove = (autoId, annonceurId, result) => {
  sql.query("DELETE FROM Followers WHERE idAuto = ? AND idAnnonceur = ?", [autoId, annonceurId], (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(null, err);
      return;
    }

    if (res.affectedRows == 0) {
      result({ kind: "not_found" }, null);
      return;
    }

    console.log("deleted Followers with idAuto: ", autoId, " And idAnnonceur", annonceurId);
    result(null, res);
  });
};

module.exports = Followers;