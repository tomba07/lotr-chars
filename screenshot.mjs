import { chromium } from '@playwright/test';

const browser = await chromium.launch();
const page = await browser.newPage();
await page.setViewportSize({ width: 1440, height: 900 });

await page.goto('http://localhost:4004/com.mt.lotr.ui/index.html');
await page.waitForSelector('.sapMListTbl tbody tr', { timeout: 15000 });
await page.locator('.sapMListTbl tbody tr').first().click();
await page.waitForTimeout(5000);

// Screenshot just the header area
const header = await page.$('.sapUxAPObjectPageHeaderContainer, .sapUxAPObjectPageHeader');
if (header) {
  await header.screenshot({ path: '/tmp/lotr-header.png' });
} else {
  await page.screenshot({ path: '/tmp/lotr-header.png', clip: { x: 0, y: 0, width: 1440, height: 250 } });
}

await browser.close();
