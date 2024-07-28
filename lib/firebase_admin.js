const admin = require('firebase-admin');
const serviceAccount = require('./firebaseAdmin.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const auth = admin.auth();

// Function to delete all users
const deleteAllUsers = (nextPageToken) => {
  auth.listUsers(1000, nextPageToken)
    .then(listUsersResult => {
      listUsersResult.users.forEach(userRecord => {
        auth.deleteUser(userRecord.uid)
          .then(() => console.log('Successfully deleted user', userRecord.uid))
          .catch(error => console.log('Error deleting user:', error));
      });
      if (listUsersResult.pageToken) {
        // Continue listing users
        deleteAllUsers(listUsersResult.pageToken);
      }
    })
    .catch(error => console.log('Error listing users:', error));
};

deleteAllUsers();
