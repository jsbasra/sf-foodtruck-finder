const { webkit, devices } = require('@playwright/test');
test('basic test', async ({ page }) => {

  const iPhone11 = devices['iPhone 11 Pro'];
  (async () => {
  const browser = await webkit.launch();
  const context = await browser.newContext({
    ...iPhone11,
    locale: 'en-US',
    geolocation: { longitude: 12.492507, latitude: 41.889938 },
    permissions: ['geolocation']
  });
  const page = await context.newPage();
  await page.goto('https://basra.win');
  expect(await page.title()).toContain('SF FoodTrucks');
  await page.click('text="Display Food Trucks"');
  await page.screenshot({ path: 'map.png' });
  await browser.close();
  expect(page.url()).toBe('https://basra.win/');

});

