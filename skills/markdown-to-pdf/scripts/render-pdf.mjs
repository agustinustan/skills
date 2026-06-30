import { createRequire } from 'module';
import { pathToFileURL } from 'url';

const require = createRequire(import.meta.url);
const { chromium } = require('/usr/local/lib/node_modules/playwright');

const [, , inputHtml, outputPdf] = process.argv;
const printScale = Number.parseFloat(process.env.MARKDOWN_TO_PDF_PRINT_SCALE || '0.75');

if (!inputHtml || !outputPdf) {
  console.error('Usage: render-pdf.mjs <input-html> <output-pdf>');
  process.exit(2);
}

if (!Number.isFinite(printScale) || printScale < 0.1 || printScale > 2) {
  console.error('MARKDOWN_TO_PDF_PRINT_SCALE must be a number between 0.1 and 2');
  process.exit(2);
}

const browser = await chromium.launch({
  executablePath: process.env.PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH || '/usr/bin/chromium',
  args: ['--no-sandbox', '--disable-setuid-sandbox'],
});

try {
  const page = await browser.newPage();
  await page.goto(pathToFileURL(inputHtml).href, { waitUntil: 'networkidle' });
  await page.emulateMedia({ media: 'print' });
  await page.pdf({
    path: outputPdf,
    format: 'A4',
    printBackground: true,
    preferCSSPageSize: true,
    scale: printScale,
  });
} finally {
  await browser.close();
}
