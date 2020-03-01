const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

var msgData;


exports.notifyTrigger = functions.firestore.document('departments/{deptId}/notifications/{notfiyId}').onCreate(async (snapshot, context) => {
    //

    if (snapshot.empty) {
        console.log('No Devices');
        return;
    }

    msgData = snapshot.data();

    const deviceIdTokens = await admin
        .firestore()
        .collection('faculty').where('department', "==", context.params.deptId)
        .get();

    const studentDevicetokens = await admin
    .firestore()
    .collection('students').where('branch', "==", context.params.deptId)
    .get();

    var tokens = [];

    for (var token of studentDevicetokens.docs) {
        tokens.push(token.data().token);

    }

    for (var tokenpay of deviceIdTokens.docs) {
        tokens.push(tokenpay.data().token);
    }

    var payload = {
        notification: {

            title: msgData.facultyName,
            body: msgData.content,
            // image: msgData.imageUrl,

            sound: 'default',
            click_action: 'FLUTTER_NOTIFICATION_CLICK'

        },

        // data: {

        // },
    };

    try {
        const response = await admin.messaging().sendToDevice(tokens, payload);
        console.log('Notification sent successfully');
    } catch (err) {
        console.log(err);
    }
});

// exports.notificationTrigger = functions.firestore.document(
//     'departments/{deptId}/notifications/{notfiyId}'
// ).onCreate(
//     async (snapshot, context) => {
//         msgData = snapshot.data();

//         admin.firestore().collection('faculty').get().then((snapshots) => {
//             var tokens = [];
//             if (snapshots.empty) {
//                 console.log("empty");
//                 return;
//             }
//             else {
//                 for (var token of snapshots.data) {
//                     tokens.push(token.data().token);
//                 }

//                 var payload = {
//                     notification: {
//                         title: msgData.facultyName,
//                         body: msgData.content,
//                     },
//                     data: {
//                         click_action: 'FLUTTER_NOTIFICATION_CLICK',
//                         message: msgData.content,
//                     },

//                 }


//                 return admin.messaging().sendToDevice(tokens, payload);
//             }
//         }).catch((err) => {
//             console.log(err);
//         });


//     }
// );
