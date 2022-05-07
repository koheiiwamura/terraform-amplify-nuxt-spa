/* eslint-disable @typescript-eslint/no-unused-vars */
function handler(event) {
  /* eslint-disable no-var */
  var request = event.request;
  /* eslint-disable no-var */
  var uri = request.uri;

  // Check whether the URI is missing a file name.
  if (uri.endsWith("/")) {
    request.uri += "index.html";
  }
  // Check whether the URI is missing a file extension.
  else if (!uri.includes(".")) {
    request.uri += "/index.html";
  }

  return request;
}
