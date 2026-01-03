# QUICK FIX: Delete Disk and Restart

## Steps (Takes ~2 minutes):

1. **Render Dashboard → Your `memos` service → "Disks" tab**

2. **Delete disk:**
   - Click `memos-data` disk
   - "Delete Disk" button
   - Confirm

3. **Add new disk:**
   - "Add Disk" button
   - Name: `memos-data`
   - Mount Path: `/var/opt/memos`
   - Size: 1 GB
   - "Create"

4. **Deploy:**
   - Go to "Manual Deploy"
   - Click "Clear build cache & deploy"

5. **Wait 2-3 minutes** for deployment

6. **Try signup again** - should work! ✅

The first user you create will automatically be the admin.

---

## Why this works:
- Removes any leftover/demo data
- Gives you a fresh database
- Ensures clean initialization
