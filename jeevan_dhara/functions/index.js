const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();
const db = admin.firestore();

// Simple health statistics function
exports.getHealthStats = functions.https.onCall(async (data, context) => {
  try {
    const { district, timeRange } = data;
    
    let startDate = new Date();
    if (timeRange === 'week') startDate.setDate(startDate.getDate() - 7);
    else if (timeRange === 'month') startDate.setMonth(startDate.getMonth() - 1);
    else startDate.setFullYear(startDate.getFullYear() - 1);

    const caseReports = await db.collection('case_reports')
      .where('district', '==', district)
      .where('createdAt', '>=', admin.firestore.Timestamp.fromDate(startDate))
      .get();

    const waterReports = await db.collection('water_quality_reports')
      .where('location', '==', district)
      .where('createdAt', '>=', admin.firestore.Timestamp.fromDate(startDate))
      .get();

    return {
      totalCaseReports: caseReports.size,
      totalWaterReports: waterReports.size,
      district,
      timeRange
    };
  } catch (error) {
    throw new functions.https.HttpsError('internal', error.message);
  }
});

// Auto-generate alerts for high-risk cases
exports.checkForOutbreaks = functions.firestore
  .document('case_reports/{reportId}')
  .onCreate(async (snap, context) => {
    const report = snap.data();
    
    // Check for potential outbreak (simplified logic)
    if (report.numberOfCases >= 5) {
      await db.collection('alerts').add({
        title: 'Potential Disease Outbreak',
        message: `High number of cases (${report.numberOfCases}) reported in ${report.village}, ${report.district}`,
        severity: 'high',
        type: 'disease_outbreak',
        affectedAreas: [report.district],
        targetRoles: ['health_official', 'asha'],
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        isActive: true,
        createdBy: 'system'
      });
    }
  });

// Send notifications for critical water quality
exports.waterQualityAlert = functions.firestore
  .document('water_quality_reports/{reportId}')
  .onCreate(async (snap, context) => {
    const report = snap.data();
    
    if (report.status === 'critical') {
      await db.collection('alerts').add({
        title: 'Critical Water Quality Alert',
        message: `Critical water quality detected at ${report.waterSourceName} in ${report.location}`,
        severity: 'high',
        type: 'water_contamination',
        affectedAreas: [report.location],
        targetRoles: ['all'],
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        isActive: true,
        createdBy: 'system'
      });
    }
  });