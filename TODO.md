# TODO - Canteen Trolley Automation updates

## Step 1: Create test-mode toggle
- [ ] Add `IsTestMode` flag support in code (read from `Web.config`).
- [ ] Create helper module `AppConfig.vb` to read config safely.

## Step 2: Update pages to use test-mode
- [ ] `PunchIn.aspx.vb`: only fallback/simulate when test mode enabled.
- [ ] `PunchOut.aspx.vb`: only fallback/simulate when test mode enabled.
- [ ] `AttendanceDetails.aspx.vb`: only dummy SP/canteen data when test mode enabled.
- [ ] `Login.aspx.vb`: only admin/admin bypass when test mode enabled.
- [ ] `MealDelivery.aspx.vb`: only dummy delivery data when test mode enabled.
- [ ] `FastTrackBooking.aspx.vb`: only allow access / simulate punch status failures in test mode.


## Step 3: Add new central config helper
- [ ] Ensure all above pages call the helper for the flag.

## Step 4: Build & verify
- [ ] Compile solution.
- [ ] Smoke test flows in test mode.


