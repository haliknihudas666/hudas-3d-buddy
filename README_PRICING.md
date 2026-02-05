# Hudas 3D Buddy - Pricing Guide

This document explains exactly how **Hudas 3D Buddy** calculates the suggested price for 3D print jobs. We use a transparent, formula-based approach to ensure fair pricing that covers materials, equipment wear, energy, labor, and potential failures.

---

## 🏗️ The Core Formula

The final price is built layer by layer (pun intended), starting from raw material cost up to the final retail price.

$$
\text{Total Cost} = \text{Base Price} + \text{Failure Buffer} + \text{Markup} + \text{Packaging} + \text{Tax} + \text{Shipping}
$$

---

## 1. 🧵 Material Cost (Filament)
We calculate the exact amount of plastic used for your model.

**Formula:**
```
Material Cost = (Price Per Gram * Weight Used) * Quantity
```

- **Price Per Gram**: Calculated from the spool price divided by spool weight.
- **Wastage Factor**: We add a `wastagePercent` (default 5%) to account for purge lines, brims, and failed starts.
  - `Effective Price = Price Per Gram * (1 + Wastage %)`

---

## 2. ⚡ Equipment Cost
We factor in the electricity used and the "lifespan cost" of the printer.

**A. Electricity Cost**
```
Electricity = (Printer Wattage / 1000) * Print Hours * Electricity Rate (₱/kWh)
```

**B. Printer Depreciation (Wear & Tear)**
We charge a small hourly fee to cover the eventual replacement of the machine.
```
Depreciation = Printer Price / Expected Lifetime Hours
```

**C. Maintenance**
Estimates yearly maintenance costs spread over hourly usage.
```
Maintenance Cost = (Yearly Maintenance / 2000 hours)
```

**Total Machine Component:**
`Machine Cost = (Electricity + Depreciation + Maintenance + Consumables) * Hours`

---

## 3. 👷 Labor Cost
This covers the time spent slicing, setting up the printer, removing the print, and monitoring the job.

**Formula:**
```
Labor Cost = Labor Rate (₱/hr) * Print Hours * Quantity
```
*Note: This currently assumes labor time is proportional to print time. Adjustable in General Settings.*

---

## 4. 🎨 Pre & Post-Processing
Optional services you can add to your job.

**Pre-Processing**:
- **Modeling**: Custom 3D design work (`₱200/hr` base).
- **Slicing**: Converting your 3D model to printer code (`₱100/hr` base).
- **Rush Order**: Adds a percentage to pre-processing costs (default +25%).

**Post-Processing**:
- **Support Removal**: Removing scaffold structures.
- **Sanding**: Smoothing surface finish.
- **Painting/Coating**: Aesthetic finishes.
- **Assembly**: Putting parts together.
*Each service has a defined hourly rate and optional flat fees.*

---

## 5. 💰 Final Adjustments

Once we have the **Subtotal** (Materials + Machine + Labor + Services), we apply safety margins:

### A. Failure Buffer
3D printing isn't perfect. We add a percentage (default ~10-20%) to cover the risk of print failures so you don't lose money on failed attempts.
```
Price + Failure Buffer = Subtotal * (1 + Failure Rate %)
```

### B. Markup (Profit Margin)
Your business profit.
```
Price + Markup = (Subtotal + Buffer) * (1 + Markup %)
```

### C. Extras
- **Packaging**: Flat fee per item.
- **Tax**: Added if enabled in settings (`Total * Tax %`).
- **Shipping**: Base shipping fee.

---

## 📝 Example Calculation

**Job**: 1x "Benchy Boat"
- **Weight**: 13g
- **Time**: 1.5 hours

| Item | Cost | Note |
|------|------|------|
| **Filament** | ₱12.50 | PLA (~₱1/g) |
| **Electricity** | ₱1.80 | @ ₱12/kWh |
| **Depreciation** | ₱15.00 | Wear & Tear |
| **Labor** | ₱75.00 | @ ₱50/hr |
| **Subtotal** | **₱104.30** | |
| + Failure (15%) | ₱15.65 | Risk buffer |
| + Markup (40%) | ₱47.98 | Profit |
| + Packaging | ₱20.00 | Box + bubble wrap |
| **Suggested Price** | **₱187.93** | |

---

*Pricing metrics are configurable in the App Settings.*
