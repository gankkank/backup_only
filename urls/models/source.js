(function() {
  var mongoose, sourceSchema;

  mongoose = require("mongoose");

  sourceSchema = mongoose.Schema({
    service: {
      type: String
    },
    version: {
      type: String,
      unique: true
    },
    url: {
      type: String,
      unique: true
    }
  });

  exports.Source = function(conn) {
    return (conn || mongoose).model("source", sourceSchema);
  };

}).call(this);
