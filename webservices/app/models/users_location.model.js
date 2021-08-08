const sql = require("../../index.js");

// constructor
const UserLocation = function(UserLocation) {
  this.idAuto = UserLocation.idAuto;
  this.latitude = UserLocation.latitude;
  this.longitude = UserLocation.longitude;
  this.isOnline = UserLocation.isOnline;
};

UserLocation.create = (newUserLocation, result) => {
  sql.query("INSERT INTO users_location SET ?", newUserLocation, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }

    console.log("created UserLocation: ", { id: res.insertId, ...newUserLocation });
    result(null, { id: res.insertId, ...newUserLocation });
  });
};

UserLocation.findById = (offreId, result) => {
  sql.query(`SELECT * FROM users_location u, revenu r WHERE r.idAuto = u.idAuto AND r.idOffre = ${offreId}`, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }

    if (res.length) {
      console.log("found UserLocation: ", res);
      result(null, res);
      return;
    }

    result({ kind: "not_found" }, null);
  });
};


UserLocation.updateById = (idAuto, UserLocation, result) => {
  sql.query(
    "UPDATE users_location SET latitude = ?, longitude = ?, isOnline = ? WHERE idAuto = ?",

    [UserLocation.latitude, UserLocation.longitude, UserLocation.isOnline, idAuto],
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

      console.log("updated UserLocation: ", { idAuto: idAuto, ...UserLocation });
      result(null, { idAuto: idAuto, ...UserLocation });
    }
  );
};

UserLocation.remove = (idAuto, result) => {
  sql.query("DELETE FROM users_location WHERE idAuto = ?", idAuto, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(null, err);
      return;
    }

    if (res.affectedRows == 0) {
      result({ kind: "not_found" }, null);
      return;
    }

    console.log("deleted UserLocation with idAuto: ", idAuto);
    result(null, res);
  });
};

module.exports = UserLocation;