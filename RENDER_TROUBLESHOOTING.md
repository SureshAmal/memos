# Render Deployment - UNIQUE Constraint Error Fix

## Error
```
constraint failed: UNIQUE constraint failed: user.username (2067)
```

## Cause
This happens when trying to create a user that already exists in the database, usually due to:
- Demo mode being active (creates demo users)
- Leftover data in the volume
- Database not properly initialized

## Quick Fix Options

### Option 1: Delete and Recreate the Disk (Recommended for Fresh Start)

1. **Go to Render Dashboard** → Your `memos` service

2. **Click "Disks" tab**

3. **Delete the existing disk:**
   - Click on `memos-data` disk
   - Click "Delete Disk"
   - Confirm deletion

4. **Create a new disk:**
   - Click "Add Disk"
   - Name: `memos-data`
   - Mount Path: `/var/opt/memos`
   - Size: `1 GB`
   - Click "Create"

5. **Trigger new deployment:**
   - Go to "Manual Deploy" → "Clear build cache & deploy"

6. **Wait for deployment** to complete

7. **Try signup again** - it should work now!

---

### Option 2: Use Different Username

If you don't want to delete data:
- Try signing up with a different username
- Avoid common usernames like: `admin`, `demo`, `memos`, `test`, `user`

---

### Option 3: Access via Shell and Reset Database

If you have existing data you want to keep but need to fix user issues:

1. **Open Shell in Render:**
   - Go to your service → "Shell" tab
   - Click "Launch Shell"

2. **Check database location:**
   ```bash
   ls -la /var/opt/memos/
   ```

3. **Backup current database:**
   ```bash
   cp /var/opt/memos/memos_prod.db /var/opt/memos/memos_prod.db.backup
   ```

4. **Reset user table (CAUTION - deletes all users):**
   ```bash
   # This requires sqlite3 which may not be installed
   # Better to delete disk and start fresh
   ```

---

## Verify Environment Variables

Make sure you're NOT in demo mode:

1. **Go to Render Dashboard** → Your service → "Environment"

2. **Check `MEMOS_MODE` value:**
   - Should be: `prod` ✅
   - Should NOT be: `demo` ❌

3. **If it's set to `demo`, change it to `prod`**

4. **Redeploy the service**

---

## Check Database File

The database file should be at: `/var/opt/memos/memos_prod.db`

If you see: `/var/opt/memos/memos_demo.db` - you're in demo mode!

---

## Fresh Start Checklist

For a completely clean deployment:

1. ✅ Delete existing disk
2. ✅ Create new disk with correct mount path
3. ✅ Verify `MEMOS_MODE=prod` (NOT demo)
4. ✅ Verify `MEMOS_PORT=5230`
5. ✅ Clear build cache and deploy
6. ✅ Wait for deployment to complete
7. ✅ Try signup with any username

---

## After Fresh Start - First User Setup

1. **Go to your Render URL:**
   ```
   https://your-service-name.onrender.com
   ```

2. **You should see the signup page**

3. **Create your first user:**
   - Username: Choose any username (this will be the admin)
   - Password: Choose a strong password
   - Email: Optional

4. **First user is automatically admin!**

---

## Alternative: Check Current Users

If you want to see what users exist:

1. **Open Shell in Render**

2. **Install sqlite3:**
   ```bash
   apk add sqlite
   ```

3. **Query users:**
   ```bash
   sqlite3 /var/opt/memos/memos_prod.db "SELECT id, username, role FROM user;"
   ```

4. **If you see existing users**, you can either:
   - Login with those credentials (if you know them)
   - Delete the disk and start fresh

---

## Still Having Issues?

Check the logs for more details:

1. **Go to Render Dashboard** → Your service → "Logs"

2. **Look for:**
   - Database initialization messages
   - Any migration errors
   - Mode confirmation (should show `prod` not `demo`)

3. **Common log messages:**
   - ✅ `"mode": "prod"` - Good!
   - ❌ `"mode": "demo"` - Change to prod!
   - ✅ `Migration finished` - Database is ready
   - ❌ `Migration failed` - Check database permissions

---

## Recommended Solution

**For your current situation, I recommend:**

1. Delete the disk in Render
2. Create a new disk with the same settings
3. Trigger a new deployment
4. Sign up with your desired username

This gives you a clean slate and should work perfectly!
