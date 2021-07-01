const { test, expect, chromium } = require('@playwright/test');
test('basic test', async () => {
  const browser = await chromium.launch();
  const context = await browser.newContext({
  geolocation: { longitude: 48.858455, latitude: 2.294474 },
  permissions: ['geolocation']
  });
  
  const page = await context.newPage();
  await page.goto('https://basra.win');
  expect(await page.title()).toContain('SF FoodTrucks');
  await page.click('text="Display Food Trucks"');
  await page.screenshot({ path: 'map.png' });
  await browser.close();
  expect(page.url()).toBe('https://basra.win/');
  //await context.setGeolocation({ longitude: 29.979097, latitude: 31.134256 });

});
