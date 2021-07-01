const { test, expect, chromium } = require('@playwright/test');
test('basic test', async () => {
  const browser = await chromium.launch();
  const context = await browser.newContext({
  geolocation: { longitude: -122.452672, latitude: 37.754043 },
  permissions: ['geolocation']
  });
  
  const page = await context.newPage();
  await page.goto('https://basra.win');
  expect(await page.title()).toContain('SF FoodTrucks');
  await page.click('text="Display Food Trucks"');
  await page.screenshot({ path: 'map.png' });
   const [msg] = await Promise.all([
    page.waitForEvent('console'),
    page.evaluate(() => {
      // Issue console.log statements inside the page.
      console.log(37.74563668388077);
    }),
  ]);
  await msg.args[0].jsonValue() 
  await browser.close();
  expect(page.url()).toBe('https://basra.win/');
  //await context.setGeolocation({ longitude: 29.979097, latitude: 31.134256 });

});
