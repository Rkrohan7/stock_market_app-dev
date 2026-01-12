import '../data/models/education_model.dart';
import '../core/enums/enums.dart';

class EducationService {
  // Demo blogs for trading education
  final List<BlogModel> _demoBlogs = [
    // BEGINNER BLOGS
    BlogModel(
      id: 'blog-1',
      title: 'What is the Stock Market? A Complete Beginner\'s Guide',
      summary: 'Learn the fundamentals of the stock market, how it works, and why millions of people invest in stocks every day.',
      content: '''
# What is the Stock Market?

The stock market is a collection of exchanges where stocks (pieces of ownership in businesses) are bought and sold. It's like a marketplace, but instead of vegetables or clothes, people trade shares of companies.

## How Does It Work?

When a company wants to raise money, it can sell parts of itself to the public through an Initial Public Offering (IPO). Once the company is "public," anyone can buy or sell its shares on the stock exchange.

### Key Components:

1. **Stock Exchanges**: In India, we have BSE (Bombay Stock Exchange) and NSE (National Stock Exchange)
2. **Stockbrokers**: They act as intermediaries between you and the exchange
3. **SEBI**: Securities and Exchange Board of India regulates the market

## Why Do Stock Prices Change?

Stock prices change based on supply and demand:
- If more people want to buy a stock (demand), the price goes up
- If more people want to sell (supply), the price goes down

### Factors Affecting Stock Prices:
- Company performance and earnings
- Industry trends
- Economic conditions
- Government policies
- Global events

## Getting Started

To start investing in stocks, you need:
1. **PAN Card**: Required for all financial transactions
2. **Demat Account**: To hold your shares electronically
3. **Trading Account**: To buy and sell shares
4. **Bank Account**: Linked for fund transfers

## Key Takeaways

- The stock market is where shares of public companies are traded
- Prices are determined by supply and demand
- Long-term investing has historically provided good returns
- Always invest what you can afford to lose
''',
      author: 'Rajesh Kumar',
      category: 'Basics',
      level: 'Beginner',
      readTimeMinutes: 8,
      tags: ['stocks', 'basics', 'investing', 'beginners'],
      publishedAt: DateTime.now().subtract(const Duration(days: 2)),
      viewCount: 15420,
      likeCount: 892,
      isFeatured: true,
    ),
    BlogModel(
      id: 'blog-2',
      title: 'How to Open a Demat Account: Step-by-Step Guide',
      summary: 'A complete walkthrough on opening your first Demat and trading account to start your investment journey.',
      content: '''
# How to Open a Demat Account

A Demat (Dematerialized) account is essential for holding your shares in electronic form. Here's everything you need to know.

## What is a Demat Account?

A Demat account holds your shares and securities in electronic format, just like a bank account holds your money. Gone are the days of physical share certificates!

## Documents Required

Before starting, gather these documents:
- **PAN Card** (mandatory)
- **Aadhaar Card** (for e-KYC)
- **Address Proof** (Passport, Voter ID, or Utility Bill)
- **Passport-size Photographs**
- **Bank Account Details** (cancelled cheque)

## Step-by-Step Process

### Step 1: Choose a Broker
Select a SEBI-registered broker. Consider:
- Brokerage charges
- Platform features
- Customer support
- Research and tools

### Step 2: Fill the Application
- Visit broker's website or app
- Fill personal details
- Upload documents
- Complete e-KYC with Aadhaar

### Step 3: In-Person Verification (IPV)
- Video call verification, or
- Visit broker's office

### Step 4: Account Activation
- Receive login credentials
- Set up password and PIN
- Link your bank account

## Charges to Know

| Type | Typical Cost |
|------|-------------|
| Account Opening | ₹0-500 |
| Annual Maintenance | ₹300-500/year |
| Brokerage | 0.01%-0.5% per trade |

## Tips for Beginners

1. Compare multiple brokers before deciding
2. Check for hidden charges
3. Ensure good mobile app experience
4. Look for educational resources
5. Start with a small amount

## Ready to Start?

Once your account is active, you're ready to place your first trade. Start small, learn consistently, and grow your portfolio over time.
''',
      author: 'Priya Sharma',
      category: 'Basics',
      level: 'Beginner',
      readTimeMinutes: 6,
      tags: ['demat', 'account', 'beginners', 'how-to'],
      publishedAt: DateTime.now().subtract(const Duration(days: 5)),
      viewCount: 12350,
      likeCount: 756,
      isFeatured: true,
    ),
    BlogModel(
      id: 'blog-3',
      title: 'Understanding Stock Market Orders: Market, Limit, and Stop-Loss',
      summary: 'Master the different types of orders you can place in the stock market and when to use each one.',
      content: '''
# Understanding Stock Market Orders

Knowing how to place the right type of order is crucial for successful trading. Let's explore the main order types.

## Market Order

A market order executes immediately at the current market price.

**When to use:**
- When you want to buy/sell quickly
- For highly liquid stocks
- When price is less important than execution

**Example:** You want to buy Reliance shares. A market order will buy at whatever price is available right now.

## Limit Order

A limit order sets the maximum price you'll pay (buy) or minimum you'll accept (sell).

**When to use:**
- When you have a target price in mind
- For less liquid stocks
- When you're not in a hurry

**Example:** Reliance is trading at ₹2,500. You place a limit buy order at ₹2,450. The order executes only if price drops to ₹2,450.

## Stop-Loss Order

A stop-loss automatically sells your stock when it reaches a certain price to limit losses.

**When to use:**
- To protect against big losses
- When you can't monitor the market
- For risk management

**Example:** You bought a stock at ₹100. You set a stop-loss at ₹90. If price falls to ₹90, it automatically sells.

## Stop-Loss with Limit (SL-L)

Combines stop-loss with a limit order for more control.

**Trigger Price:** The price at which your order gets activated
**Limit Price:** The actual price at which you want to sell

## Order Validity

- **Day Order:** Valid only for the trading day
- **IOC (Immediate or Cancel):** Execute immediately or cancel
- **GTC (Good Till Cancelled):** Remains active until executed or cancelled

## Pro Tips

1. Always use stop-loss orders to manage risk
2. Use limit orders for better price control
3. Avoid market orders during high volatility
4. Review your orders before market opens
5. Set realistic price targets

## Summary Table

| Order Type | Price Control | Speed | Best For |
|------------|--------------|-------|----------|
| Market | None | Fastest | Quick execution |
| Limit | Full | Slower | Target price |
| Stop-Loss | Partial | Auto | Risk management |
''',
      author: 'Amit Verma',
      category: 'Basics',
      level: 'Beginner',
      readTimeMinutes: 7,
      tags: ['orders', 'trading', 'market-order', 'limit-order', 'stop-loss'],
      publishedAt: DateTime.now().subtract(const Duration(days: 7)),
      viewCount: 9870,
      likeCount: 634,
      isFeatured: false,
    ),
    BlogModel(
      id: 'blog-4',
      title: 'Introduction to Candlestick Charts',
      summary: 'Learn to read candlestick charts, the most popular charting method used by traders worldwide.',
      content: '''
# Introduction to Candlestick Charts

Candlestick charts originated in Japan over 200 years ago and are now the most popular way to visualize price movements.

## Anatomy of a Candlestick

Each candlestick shows four pieces of information:
- **Open:** Starting price
- **High:** Highest price reached
- **Low:** Lowest price reached
- **Close:** Ending price

### The Body
The rectangular part shows the range between open and close:
- **Green/White:** Close > Open (bullish)
- **Red/Black:** Close < Open (bearish)

### The Wicks (Shadows)
Lines extending from the body show the high and low:
- Upper wick: Highest price
- Lower wick: Lowest price

## Basic Patterns

### Bullish Patterns

**1. Hammer**
- Small body at the top
- Long lower wick
- Appears at bottom of downtrend
- Signals potential reversal up

**2. Bullish Engulfing**
- Green candle completely covers previous red candle
- Strong reversal signal

**3. Morning Star**
- Three candle pattern
- Red candle → Small candle → Green candle
- Indicates trend reversal

### Bearish Patterns

**1. Shooting Star**
- Small body at the bottom
- Long upper wick
- Appears at top of uptrend
- Signals potential reversal down

**2. Bearish Engulfing**
- Red candle completely covers previous green candle
- Strong sell signal

**3. Evening Star**
- Opposite of Morning Star
- Green candle → Small candle → Red candle

## Doji Candles

When open and close are nearly equal:
- Shows market indecision
- Can signal potential reversal
- Types: Standard, Dragonfly, Gravestone

## Reading Tips

1. **Context matters:** Look at surrounding candles
2. **Volume confirms:** High volume = stronger signal
3. **Timeframe:** Same pattern means more on daily vs 5-min chart
4. **Don't trade single candles:** Wait for confirmation

## Practice Exercise

Open any stock chart and try to identify:
- 5 green (bullish) candles
- 5 red (bearish) candles
- 1 hammer pattern
- 1 doji

The more you practice, the better you'll get at reading price action!
''',
      author: 'Neha Gupta',
      category: 'Technical Analysis',
      level: 'Beginner',
      readTimeMinutes: 10,
      tags: ['candlestick', 'charts', 'technical-analysis', 'patterns'],
      publishedAt: DateTime.now().subtract(const Duration(days: 10)),
      viewCount: 18540,
      likeCount: 1205,
      isFeatured: true,
    ),
    BlogModel(
      id: 'blog-5',
      title: 'Risk Management: The Golden Rules of Trading',
      summary: 'Learn essential risk management techniques that separate successful traders from the rest.',
      content: '''
# Risk Management: The Golden Rules of Trading

Risk management is the most important skill in trading. Without it, even the best strategy will fail.

## Why Risk Management Matters

- Protects your capital from big losses
- Keeps you in the game long enough to succeed
- Reduces emotional decision-making
- Allows for consistent growth

## The 1% Rule

**Never risk more than 1-2% of your capital on a single trade.**

Example:
- Capital: ₹1,00,000
- Max risk per trade: ₹1,000-2,000

This means if your stop-loss is hit, you lose only 1-2% of your total capital.

## Position Sizing Formula

Position Size = Risk Amount ÷ (Entry Price - Stop Loss)

**Example:**
- Capital: ₹1,00,000
- Risk: 1% = ₹1,000
- Stock Price: ₹500
- Stop Loss: ₹480
- Risk per share: ₹20

Position Size = ₹1,000 ÷ ₹20 = 50 shares

## Risk-Reward Ratio

Always aim for trades where potential reward > risk.

**Minimum ratio: 1:2**
- If risking ₹1,000, target at least ₹2,000 profit

**Example:**
- Entry: ₹100
- Stop Loss: ₹95 (Risk: ₹5)
- Target: ₹110 (Reward: ₹10)
- Risk:Reward = 1:2 ✓

## Diversification Rules

1. **Don't put all eggs in one basket**
2. **Sector diversification:** Max 20-25% in one sector
3. **Stock diversification:** Max 5-10% in one stock
4. **Asset classes:** Mix stocks, bonds, gold, etc.

## Stop-Loss Strategies

### Fixed Percentage Stop
- Set stop at fixed % below entry (e.g., 5%)

### Technical Stop
- Place below support levels
- Below moving averages

### Trailing Stop
- Moves up as price increases
- Locks in profits

## Common Mistakes to Avoid

1. ❌ Averaging down on losing positions
2. ❌ Removing stop-loss hoping price will recover
3. ❌ Revenge trading after a loss
4. ❌ Risking money you can't afford to lose
5. ❌ Overtrading

## Daily Risk Limit

Set a maximum daily loss limit. If hit, stop trading for the day.

**Example:** Stop trading if daily loss exceeds 3% of capital.

## Key Takeaways

- Risk management keeps you in the game
- Never risk more than 1-2% per trade
- Always maintain positive risk-reward ratio
- Diversify your portfolio
- Use stop-losses religiously

**Remember:** In trading, protecting your capital is more important than making profits.
''',
      author: 'Vikram Patel',
      category: 'Risk Management',
      level: 'Beginner',
      readTimeMinutes: 9,
      tags: ['risk-management', 'trading', 'stop-loss', 'position-sizing'],
      publishedAt: DateTime.now().subtract(const Duration(days: 3)),
      viewCount: 14280,
      likeCount: 987,
      isFeatured: true,
    ),

    // INTERMEDIATE BLOGS
    BlogModel(
      id: 'blog-6',
      title: 'Technical Indicators: RSI, MACD, and Moving Averages Explained',
      summary: 'Deep dive into the most popular technical indicators and how to use them in your trading strategy.',
      content: '''
# Technical Indicators: RSI, MACD, and Moving Averages

Technical indicators help traders make informed decisions by analyzing price patterns and market momentum.

## Moving Averages

Moving averages smooth out price data to identify trends.

### Simple Moving Average (SMA)
Average of closing prices over a period.

**Popular SMAs:**
- 20 SMA: Short-term trend
- 50 SMA: Medium-term trend
- 200 SMA: Long-term trend

### Exponential Moving Average (EMA)
Gives more weight to recent prices, more responsive than SMA.

### Trading Signals

**Golden Cross:** 50 SMA crosses above 200 SMA → Bullish
**Death Cross:** 50 SMA crosses below 200 SMA → Bearish

## RSI (Relative Strength Index)

RSI measures the speed and magnitude of price changes on a scale of 0-100.

### Interpretation
- **Above 70:** Overbought (potential sell)
- **Below 30:** Oversold (potential buy)
- **50 line:** Trend direction

### RSI Divergence
- **Bullish Divergence:** Price makes lower low, RSI makes higher low
- **Bearish Divergence:** Price makes higher high, RSI makes lower high

### Settings
Default period: 14
- Shorter period (7): More sensitive
- Longer period (21): Smoother

## MACD (Moving Average Convergence Divergence)

MACD shows relationship between two EMAs.

### Components
1. **MACD Line:** 12 EMA - 26 EMA
2. **Signal Line:** 9 EMA of MACD Line
3. **Histogram:** MACD Line - Signal Line

### Trading Signals

**Bullish:**
- MACD crosses above signal line
- Histogram turns positive
- MACD crosses above zero line

**Bearish:**
- MACD crosses below signal line
- Histogram turns negative
- MACD crosses below zero line

## Combining Indicators

Don't rely on single indicator. Use multiple confirmations:

### Example Strategy
**Buy when:**
1. Price above 200 SMA (uptrend)
2. RSI between 40-50 (not overbought)
3. MACD crosses above signal line

**Sell when:**
1. RSI above 70
2. MACD histogram declining
3. Price touches upper Bollinger Band

## Indicator Settings by Timeframe

| Timeframe | SMA | RSI | Use Case |
|-----------|-----|-----|----------|
| 5-15 min | 9, 21 | 7-9 | Scalping |
| 1 hour | 20, 50 | 14 | Day trading |
| Daily | 50, 200 | 14 | Swing trading |

## Common Mistakes

1. Using too many indicators
2. Ignoring price action
3. Not considering the trend
4. Over-optimizing settings
5. Trading against the trend

## Pro Tips

- Indicators lag; price action leads
- Use indicators for confirmation, not primary signals
- Backtest before using in live trading
- Adapt settings to the stock's volatility
''',
      author: 'Suresh Menon',
      category: 'Technical Analysis',
      level: 'Intermediate',
      readTimeMinutes: 12,
      tags: ['RSI', 'MACD', 'moving-averages', 'technical-analysis', 'indicators'],
      publishedAt: DateTime.now().subtract(const Duration(days: 8)),
      viewCount: 11250,
      likeCount: 823,
      isFeatured: false,
    ),
    BlogModel(
      id: 'blog-7',
      title: 'Support and Resistance: Finding Key Price Levels',
      summary: 'Master the art of identifying support and resistance levels for better entry and exit points.',
      content: '''
# Support and Resistance: Finding Key Price Levels

Support and resistance are foundational concepts in technical analysis that every trader must master.

## What is Support?

Support is a price level where buying pressure exceeds selling pressure, preventing further decline.

**Think of it as:** A floor where price tends to bounce

### Why Support Works
- Buyers see value at this level
- Previous buyers who missed out want to enter
- Short sellers take profits

## What is Resistance?

Resistance is a price level where selling pressure exceeds buying pressure, preventing further rise.

**Think of it as:** A ceiling where price tends to stop

### Why Resistance Works
- Sellers see prices as high enough
- Buyers who bought lower want to sell
- Short sellers enter positions

## How to Identify Levels

### Method 1: Historical Price Points
Look for prices where:
- Price reversed multiple times
- High trading volume occurred
- Significant highs and lows formed

### Method 2: Round Numbers
Psychological levels like:
- ₹100, ₹500, ₹1,000
- ₹10,000 for Nifty

### Method 3: Moving Averages
- 20, 50, 200 day EMAs
- Often act as dynamic support/resistance

### Method 4: Fibonacci Retracements
Key levels: 23.6%, 38.2%, 50%, 61.8%, 78.6%

## The Role Reversal Principle

**When support breaks, it becomes resistance.**
**When resistance breaks, it becomes support.**

This is one of the most reliable patterns in trading.

## Trading Strategies

### Strategy 1: Bounce Trading
- Buy at support
- Sell at resistance
- Works in ranging markets

### Strategy 2: Breakout Trading
- Buy when resistance breaks
- Sell when support breaks
- Works in trending markets

### Strategy 3: Pullback Entry
- Wait for breakout
- Enter on pullback to broken level
- More conservative approach

## Strength of Levels

Stronger levels have:
1. **Multiple touches:** More tests = stronger level
2. **Timeframe:** Higher timeframe levels are stronger
3. **Volume:** High volume at level = important
4. **Recency:** Recent levels more relevant
5. **Confluence:** Multiple factors at same level

## Drawing Support/Resistance

### For Support
- Connect the lows
- Focus on wicks AND bodies
- Treat as zones, not exact lines

### For Resistance
- Connect the highs
- Include failed breakout attempts
- Use zones of 1-2% width

## Common Mistakes

1. Drawing too many lines
2. Forcing lines to fit
3. Ignoring the trend
4. Not adjusting levels as market moves
5. Treating levels as exact prices

## Pro Tips

- Use zones, not exact lines
- Higher timeframe levels are more important
- Volume confirms the importance of levels
- Don't fight strong levels
- Be patient for quality setups
''',
      author: 'Kavita Reddy',
      category: 'Technical Analysis',
      level: 'Intermediate',
      readTimeMinutes: 11,
      tags: ['support', 'resistance', 'price-levels', 'technical-analysis'],
      publishedAt: DateTime.now().subtract(const Duration(days: 12)),
      viewCount: 9560,
      likeCount: 712,
      isFeatured: false,
    ),
    BlogModel(
      id: 'blog-8',
      title: 'Fundamental Analysis: How to Read Financial Statements',
      summary: 'Learn to analyze balance sheets, income statements, and cash flow statements like a pro investor.',
      content: '''
# Fundamental Analysis: How to Read Financial Statements

Understanding financial statements is essential for long-term investors. Let's break down the three main statements.

## The Three Financial Statements

1. **Balance Sheet:** What the company owns and owes
2. **Income Statement:** How much money the company made
3. **Cash Flow Statement:** Where the money actually went

## Balance Sheet

Shows the company's financial position at a specific point in time.

### Assets (What Company Owns)
**Current Assets:** Cash, inventory, receivables
**Non-Current Assets:** Property, equipment, goodwill

### Liabilities (What Company Owes)
**Current Liabilities:** Short-term debt, payables
**Non-Current Liabilities:** Long-term debt, bonds

### Shareholders' Equity
Assets - Liabilities = Equity

### Key Metrics
- **Current Ratio:** Current Assets / Current Liabilities (>1.5 is good)
- **Debt-to-Equity:** Total Debt / Equity (<1 is good)
- **Book Value:** Equity / Shares Outstanding

## Income Statement (P&L)

Shows profitability over a period of time.

### Structure
```
Revenue (Sales)
- Cost of Goods Sold (COGS)
= Gross Profit

- Operating Expenses
= Operating Profit (EBIT)

- Interest & Taxes
= Net Profit
```

### Key Metrics
- **Gross Margin:** Gross Profit / Revenue
- **Operating Margin:** EBIT / Revenue
- **Net Margin:** Net Profit / Revenue
- **EPS:** Net Profit / Shares Outstanding

## Cash Flow Statement

Shows actual cash movement in the business.

### Three Sections

**1. Operating Activities**
- Cash from core business operations
- Should be positive and growing

**2. Investing Activities**
- Capital expenditure (CAPEX)
- Investments and acquisitions

**3. Financing Activities**
- Debt raised/repaid
- Equity issued/buybacks
- Dividends paid

### Free Cash Flow
Operating Cash Flow - CAPEX = FCF

FCF is what's available for shareholders.

## Important Ratios

### Valuation Ratios
| Ratio | Formula | Good Value |
|-------|---------|------------|
| P/E | Price / EPS | <20-25 |
| P/B | Price / Book Value | <3 |
| EV/EBITDA | Enterprise Value / EBITDA | <10 |

### Profitability Ratios
| Ratio | Formula | Good Value |
|-------|---------|------------|
| ROE | Net Income / Equity | >15% |
| ROCE | EBIT / Capital Employed | >15% |
| ROA | Net Income / Assets | >5% |

### Efficiency Ratios
| Ratio | Purpose |
|-------|---------|
| Inventory Turnover | How fast inventory sells |
| Receivables Days | How fast customers pay |
| Asset Turnover | Revenue per rupee of assets |

## Red Flags to Watch

1. Revenue growing but profit declining
2. Cash flow much lower than net profit
3. Increasing debt without growth
4. Declining margins year over year
5. Frequent write-offs and one-time charges

## Analysis Checklist

✓ Is revenue growing consistently?
✓ Are margins stable or improving?
✓ Is the company generating positive cash flow?
✓ Is debt manageable?
✓ Is ROE above 15%?
✓ Is management shareholder-friendly?

## Where to Find Data

- Company's investor relations website
- BSE/NSE websites
- Screener.in
- Moneycontrol
- Annual Reports (best source)
''',
      author: 'Arjun Mehta',
      category: 'Fundamental Analysis',
      level: 'Intermediate',
      readTimeMinutes: 14,
      tags: ['fundamental-analysis', 'financial-statements', 'balance-sheet', 'investing'],
      publishedAt: DateTime.now().subtract(const Duration(days: 15)),
      viewCount: 8920,
      likeCount: 654,
      isFeatured: false,
    ),
    BlogModel(
      id: 'blog-9',
      title: 'Swing Trading Strategies for Consistent Profits',
      summary: 'Discover proven swing trading strategies that can help you capture medium-term price moves.',
      content: '''
# Swing Trading Strategies for Consistent Profits

Swing trading captures price movements over days to weeks. It's ideal for those who can't watch markets all day.

## What is Swing Trading?

Swing trading involves holding positions for 2-10 days (sometimes weeks) to profit from expected price moves.

### Advantages
- Less time-intensive than day trading
- Can be done with a full-time job
- Captures larger moves than scalping
- Lower transaction costs

### Disadvantages
- Overnight risk
- Requires patience
- Needs good timing

## Strategy 1: Trend Following

**"The trend is your friend"**

### Setup
1. Identify stocks in clear uptrend (higher highs, higher lows)
2. Wait for pullback to support
3. Enter on signs of bounce
4. Target previous high or higher

### Rules
- Only trade in direction of trend
- Use 20 and 50 EMA for trend direction
- Entry on pullback to 20 EMA
- Stop below recent swing low

## Strategy 2: Breakout Trading

Captures strong moves when price breaks key levels.

### Setup
1. Identify consolidation pattern
2. Wait for breakout with volume
3. Enter on successful breakout
4. Target = pattern height added to breakout point

### Patterns to Watch
- Triangles (ascending, descending, symmetrical)
- Rectangles (trading ranges)
- Cup and handle
- Flags and pennants

## Strategy 3: Mean Reversion

Profits from overextended moves returning to average.

### Setup
1. Find stocks far from their moving average
2. Wait for reversal candle
3. Enter toward the mean
4. Target: 20-50 EMA

### Indicators Used
- Bollinger Bands (2 standard deviations)
- RSI extremes (<30 or >70)
- Distance from 20 EMA

## Strategy 4: MACD Crossover

Uses MACD signals for entry and exit.

### Buy Signal
1. Stock in uptrend (above 200 SMA)
2. MACD line crosses above signal line
3. Histogram turns positive
4. Enter next day's open

### Sell Signal
1. MACD line crosses below signal line
2. Or RSI reaches overbought
3. Or target reached

## Stock Selection Criteria

### Technical Filters
- Price above 200 SMA
- Relative strength > market
- Good volume (>1 lakh shares/day)
- Clear chart patterns

### Fundamental Filters
- Market cap > 1000 Cr
- Positive earnings growth
- Reasonable valuations
- Strong sector

## Position Management

### Entry
- Use limit orders
- Enter in 2-3 tranches
- Wait for confirmation

### Stop Loss
- Below recent swing low
- Below key support
- 5-8% max from entry

### Target
- Previous resistance
- Risk:Reward minimum 1:2
- Scale out at multiple targets

## Sample Trade Plan

**Stock:** ABC Ltd
**Setup:** Pullback to 20 EMA in uptrend

| Parameter | Value |
|-----------|-------|
| Entry | ₹500 |
| Stop Loss | ₹475 (5%) |
| Target 1 | ₹540 (8%) |
| Target 2 | ₹575 (15%) |
| Risk:Reward | 1:3 |
| Position Size | 2% of capital |

## Weekly Routine

**Weekend:**
- Scan for setups
- Review watchlist
- Plan next week's trades

**Daily:**
- Monitor open positions
- Adjust stops if needed
- Execute planned entries

## Common Mistakes

1. Overtrading - quality over quantity
2. Fighting the trend
3. Moving stops to avoid losses
4. Taking profits too early
5. Not having a plan before entering
''',
      author: 'Deepak Sinha',
      category: 'Trading Strategies',
      level: 'Intermediate',
      readTimeMinutes: 13,
      tags: ['swing-trading', 'strategies', 'trading', 'technical-analysis'],
      publishedAt: DateTime.now().subtract(const Duration(days: 6)),
      viewCount: 10340,
      likeCount: 789,
      isFeatured: true,
    ),
    BlogModel(
      id: 'blog-10',
      title: 'Chart Patterns Every Trader Must Know',
      summary: 'Complete guide to classic chart patterns - from triangles to head and shoulders.',
      content: '''
# Chart Patterns Every Trader Must Know

Chart patterns are formations that predict future price movement. Mastering them gives you an edge.

## Reversal Patterns

### Head and Shoulders

**Formation:**
- Left shoulder: Peak and pullback
- Head: Higher peak and pullback
- Right shoulder: Lower peak (similar to left)
- Neckline: Connect the two lows

**Trading:**
- Entry: Break below neckline
- Target: Distance from head to neckline
- Stop: Above right shoulder

**Inverse Head & Shoulders:** Opposite formation, signals bullish reversal.

### Double Top / Double Bottom

**Double Top:**
- Two peaks at similar level
- Trough between them (neckline)
- Bearish reversal pattern

**Double Bottom:**
- Two troughs at similar level
- Peak between them
- Bullish reversal pattern

**Target:** Height of pattern from neckline

### Triple Top / Triple Bottom

- More powerful than double patterns
- Three peaks/troughs at similar levels
- Very reliable when it forms

## Continuation Patterns

### Triangles

**Ascending Triangle:**
- Flat top (resistance)
- Rising bottom (higher lows)
- Bullish breakout expected
- Target: Width of triangle base

**Descending Triangle:**
- Flat bottom (support)
- Falling top (lower highs)
- Bearish breakout expected

**Symmetrical Triangle:**
- Both lines converging
- Breakout direction uncertain
- Trade the breakout

### Flags and Pennants

**Bull Flag:**
- Strong up move (pole)
- Small downward consolidation (flag)
- Bullish continuation

**Bear Flag:**
- Strong down move
- Small upward consolidation
- Bearish continuation

**Target:** Length of pole added to breakout

### Wedges

**Rising Wedge:**
- Both lines slope up but converge
- Bearish pattern
- Breaks down

**Falling Wedge:**
- Both lines slope down but converge
- Bullish pattern
- Breaks up

## Trading Rules

### Entry
- Wait for confirmed breakout
- Volume should increase on breakout
- Consider pullback entry for safety

### Stop Loss
- Outside the pattern
- Other side of breakout point

### Target
- Measure the pattern height
- Add/subtract from breakout point

## Pattern Reliability

### Most Reliable
1. Head and Shoulders (>80%)
2. Double Bottom (>75%)
3. Bull Flag (>70%)

### Moderately Reliable
1. Triangles (65-70%)
2. Cup and Handle (65-70%)
3. Rectangles (60-65%)

## Tips for Pattern Trading

1. **Higher timeframe = More reliable**
2. **Volume confirms breakout**
3. **Wait for close, not wick**
4. **False breakouts happen - use stops**
5. **Pattern within pattern = Stronger**

## Scanning for Patterns

### Manual Scanning
- Review 50-100 charts weekly
- Focus on liquid stocks
- Mark patterns on watchlist

### Using Screeners
- ChartInk for Indian markets
- TradingView pattern recognition
- Set alerts for breakouts

## Pattern Failure

Not all patterns work. When they fail:

1. Don't average down
2. Accept the stop loss
3. Move on to next trade
4. Review what went wrong

**Remember:** Pattern trading is probability, not certainty. Manage risk accordingly.
''',
      author: 'Ravi Kumar',
      category: 'Technical Analysis',
      level: 'Intermediate',
      readTimeMinutes: 12,
      tags: ['chart-patterns', 'technical-analysis', 'head-shoulders', 'triangles'],
      publishedAt: DateTime.now().subtract(const Duration(days: 18)),
      viewCount: 8750,
      likeCount: 621,
      isFeatured: false,
    ),

    // ADVANCED BLOGS
    BlogModel(
      id: 'blog-11',
      title: 'Options Trading: Complete Guide to Calls and Puts',
      summary: 'Master options trading from basics to advanced strategies. Learn how calls and puts work.',
      content: '''
# Options Trading: Complete Guide to Calls and Puts

Options are powerful derivatives that can amplify returns and hedge risk. Let's master them.

## What are Options?

Options give you the right (not obligation) to buy or sell an underlying asset at a predetermined price before expiry.

### Key Terms
- **Strike Price:** Price at which you can buy/sell
- **Premium:** Price paid for the option
- **Expiry:** Date when option expires
- **Lot Size:** Minimum quantity you must trade

## Call Options

A call option gives you the right to BUY the underlying.

### When to Buy Calls
- You expect price to go UP
- Want limited risk with unlimited reward
- Bullish on the stock

### Example
- Nifty at 20,000
- Buy 20,000 CE (Call) @ ₹200 premium
- If Nifty goes to 20,500: Option worth ₹500
- Profit: ₹500 - ₹200 = ₹300 per unit

### Profit/Loss
- Max Loss: Premium paid
- Max Profit: Unlimited
- Breakeven: Strike + Premium

## Put Options

A put option gives you the right to SELL the underlying.

### When to Buy Puts
- You expect price to go DOWN
- Want to hedge long positions
- Bearish on the stock

### Example
- Nifty at 20,000
- Buy 20,000 PE (Put) @ ₹200 premium
- If Nifty falls to 19,500: Option worth ₹500
- Profit: ₹500 - ₹200 = ₹300 per unit

## Option Moneyness

### In-The-Money (ITM)
- Call: Stock price > Strike price
- Put: Stock price < Strike price
- Has intrinsic value

### At-The-Money (ATM)
- Stock price ≈ Strike price
- Most liquid options

### Out-of-The-Money (OTM)
- Call: Stock price < Strike price
- Put: Stock price > Strike price
- No intrinsic value

## Option Greeks

### Delta (Δ)
How much option price changes with ₹1 change in underlying
- Calls: 0 to 1
- Puts: -1 to 0
- ATM options: ~0.5

### Theta (θ)
Time decay - how much value option loses per day
- Always negative for buyers
- Accelerates near expiry

### Vega (V)
Sensitivity to volatility changes
- High vega = more sensitive to IV

### Gamma (Γ)
Rate of change of delta
- Highest for ATM options near expiry

## Basic Strategies

### 1. Long Call (Bullish)
- Buy Call option
- Max loss: Premium
- Max profit: Unlimited

### 2. Long Put (Bearish)
- Buy Put option
- Max loss: Premium
- Max profit: Strike - Premium

### 3. Covered Call (Neutral-Bullish)
- Own shares + Sell Call
- Limited upside, income generation

### 4. Protective Put (Hedging)
- Own shares + Buy Put
- Insurance against downside

## Option Selling

Selling options collects premium but carries more risk.

### Selling Calls
- Neutral to bearish view
- Profit from time decay
- Risk: Unlimited if wrong

### Selling Puts
- Neutral to bullish view
- Willing to buy at strike price
- Risk: Strike - Premium

## Position Sizing for Options

- Never risk more than 2-5% of capital per trade
- OTM options: Expect to lose the premium
- Size based on maximum loss, not premium

## Common Mistakes

1. Buying far OTM options
2. Ignoring time decay
3. Not having exit plan
4. Over-leveraging
5. Trading without understanding Greeks

## Tips for Success

1. Start with buying options (limited risk)
2. Trade liquid options only
3. Avoid holding till expiry
4. Understand IV before trading
5. Paper trade before going live
''',
      author: 'Sanjay Bansal',
      category: 'Options',
      level: 'Advanced',
      readTimeMinutes: 15,
      tags: ['options', 'calls', 'puts', 'derivatives', 'advanced'],
      publishedAt: DateTime.now().subtract(const Duration(days: 4)),
      viewCount: 12890,
      likeCount: 934,
      isFeatured: true,
    ),
    BlogModel(
      id: 'blog-12',
      title: 'Advanced Option Strategies: Spreads, Straddles, and Iron Condors',
      summary: 'Learn professional option strategies used by institutional traders to profit in any market.',
      content: '''
# Advanced Option Strategies

Move beyond basic calls and puts to professional-grade strategies.

## Vertical Spreads

### Bull Call Spread
**Setup:** Buy lower strike call + Sell higher strike call

**Example (Nifty at 20,000):**
- Buy 20,000 CE @ ₹200
- Sell 20,200 CE @ ₹100
- Net debit: ₹100

**Profit/Loss:**
- Max profit: ₹200 - ₹100 = ₹100 (at 20,200+)
- Max loss: ₹100 (below 20,000)
- Breakeven: 20,100

**When to use:** Moderately bullish, want to reduce cost

### Bear Put Spread
**Setup:** Buy higher strike put + Sell lower strike put

**When to use:** Moderately bearish

### Bull Put Spread (Credit Spread)
**Setup:** Sell higher strike put + Buy lower strike put

**Collect premium, profit if price stays above sold strike**

### Bear Call Spread (Credit Spread)
**Setup:** Sell lower strike call + Buy higher strike call

## Straddles and Strangles

### Long Straddle
**Setup:** Buy ATM Call + Buy ATM Put (same strike, same expiry)

**Example (Nifty at 20,000):**
- Buy 20,000 CE @ ₹200
- Buy 20,000 PE @ ₹200
- Total cost: ₹400

**When to use:** Expect big move, unsure of direction

**Breakeven:** 20,400 or 19,600

### Long Strangle
**Setup:** Buy OTM Call + Buy OTM Put

**Cheaper than straddle but needs bigger move**

### Short Straddle
**Setup:** Sell ATM Call + Sell ATM Put

**When to use:** Expect low volatility, range-bound market

**Risk:** Unlimited on both sides

## Iron Condor

**The favorite strategy of option sellers**

### Setup
1. Sell OTM Put
2. Buy further OTM Put (protection)
3. Sell OTM Call
4. Buy further OTM Call (protection)

### Example (Nifty at 20,000)
- Buy 19,500 PE @ ₹50
- Sell 19,700 PE @ ₹100
- Sell 20,300 CE @ ₹100
- Buy 20,500 CE @ ₹50

**Net credit: ₹100**

### Profit Zone
Stock stays between 19,700 and 20,300

### Risk Management
- Max loss defined by wing width
- Adjust if price approaches short strikes

## Butterfly Spread

### Long Call Butterfly
**Setup:**
- Buy 1 lower strike call
- Sell 2 middle strike calls
- Buy 1 higher strike call

**Low cost, profits if stock stays near middle strike**

### Iron Butterfly
**Setup:**
- Sell ATM Call + Sell ATM Put
- Buy OTM Call + Buy OTM Put

**Higher premium collection than iron condor**

## Calendar Spreads

**Setup:** Same strike, different expiries

### Long Calendar
- Sell near-term option
- Buy far-term option

**Profits from time decay differential**

### When to Use
- Expect stock to stay near strike
- Lower volatility expected short-term

## Strategy Selection Guide

| Market View | Volatility View | Strategy |
|-------------|-----------------|----------|
| Bullish | High | Long Call |
| Bullish | Low | Bull Call Spread |
| Bearish | High | Long Put |
| Bearish | Low | Bear Put Spread |
| Neutral | High | Iron Condor |
| Neutral | Low | Short Straddle |
| Big Move | Either | Long Straddle |

## Risk Management for Strategies

1. **Position size:** Max 5% of capital per strategy
2. **Adjustment rules:** Define before entry
3. **Exit points:** Don't let losers run
4. **Diversification:** Multiple strategies, expiries
5. **Greeks monitoring:** Keep portfolio delta neutral

## Pro Tips

1. Start with defined-risk strategies
2. Paper trade complex strategies first
3. Understand max loss before entry
4. Factor in transaction costs
5. Monitor IV levels before trading
''',
      author: 'Manish Jain',
      category: 'Options',
      level: 'Advanced',
      readTimeMinutes: 16,
      tags: ['options', 'spreads', 'straddle', 'iron-condor', 'advanced'],
      publishedAt: DateTime.now().subtract(const Duration(days: 9)),
      viewCount: 7890,
      likeCount: 567,
      isFeatured: false,
    ),
    BlogModel(
      id: 'blog-13',
      title: 'Algorithmic Trading: Building Your First Trading Bot',
      summary: 'Introduction to algorithmic trading and how to build automated trading systems.',
      content: '''
# Algorithmic Trading: Building Your First Trading Bot

Algorithmic trading uses computer programs to execute trades based on predefined rules.

## What is Algorithmic Trading?

Algo trading automates the trading process using:
- Mathematical models
- Technical indicators
- Statistical analysis
- Machine learning

### Advantages
- No emotional trading
- Faster execution
- Can monitor multiple markets
- Backtesting capability
- Consistent execution

### Disadvantages
- Technical knowledge required
- System failures possible
- Over-optimization risk
- Market regime changes

## Prerequisites

### Knowledge Required
- Programming (Python recommended)
- Statistics and probability
- Technical analysis
- Market microstructure
- Risk management

### Tools Needed
- Programming environment (Python + IDE)
- Data feed (historical and real-time)
- Broker API access
- Backtesting framework

## Building Your First Strategy

### Step 1: Define the Strategy

**Example: Moving Average Crossover**
- Buy when 20 EMA crosses above 50 EMA
- Sell when 20 EMA crosses below 50 EMA
- Apply stop-loss of 2%

### Step 2: Get Historical Data

```python
import yfinance as yf

# Download data
data = yf.download("RELIANCE.NS",
                   start="2020-01-01",
                   end="2024-01-01")
```

### Step 3: Calculate Indicators

```python
import pandas as pd

# Calculate EMAs
data['EMA20'] = data['Close'].ewm(span=20).mean()
data['EMA50'] = data['Close'].ewm(span=50).mean()

# Generate signals
data['Signal'] = 0
data.loc[data['EMA20'] > data['EMA50'], 'Signal'] = 1
data.loc[data['EMA20'] < data['EMA50'], 'Signal'] = -1
```

### Step 4: Backtest

```python
# Calculate returns
data['Returns'] = data['Close'].pct_change()
data['Strategy_Returns'] = data['Signal'].shift(1) * data['Returns']

# Calculate cumulative returns
cumulative = (1 + data['Strategy_Returns']).cumprod()
```

### Step 5: Evaluate Performance

**Key Metrics:**
- Total Return
- CAGR (Compound Annual Growth Rate)
- Sharpe Ratio
- Maximum Drawdown
- Win Rate

## Popular Algo Strategies

### 1. Mean Reversion
- Price tends to return to average
- Buy oversold, sell overbought
- Use Bollinger Bands, RSI

### 2. Momentum
- Winners keep winning short-term
- Buy high RS stocks
- Use relative strength, ROC

### 3. Statistical Arbitrage
- Exploit price inefficiencies
- Pairs trading
- Requires sophisticated modeling

### 4. Market Making
- Provide liquidity
- Profit from bid-ask spread
- High frequency required

## Risk Management in Algos

### Position Sizing
```python
risk_per_trade = 0.02  # 2% of capital
stop_loss_pct = 0.05   # 5% stop loss

position_size = (capital * risk_per_trade) / stop_loss_pct
```

### Circuit Breakers
- Daily loss limit
- Max drawdown threshold
- Unusual volatility pause

### Monitoring
- Real-time P&L tracking
- Alert systems
- Kill switch capability

## Backtesting Best Practices

1. **Use out-of-sample data**
2. **Account for slippage**
3. **Include transaction costs**
4. **Avoid look-ahead bias**
5. **Test multiple market conditions**
6. **Be skeptical of perfect results**

## Going Live

### Paper Trading
- Test with simulated money first
- Run for at least 1-3 months
- Compare with backtest results

### Start Small
- Begin with minimum lot sizes
- Gradually increase if profitable
- Monitor closely initially

## Tools and Platforms

### For Learning
- QuantConnect
- Backtrader (Python)
- Zipline

### Indian Broker APIs
- Zerodha Kite Connect
- Upstox API
- Angel Broking SmartAPI

## Common Pitfalls

1. Overfitting to historical data
2. Ignoring market impact
3. Underestimating latency
4. No proper risk management
5. Over-leveraging

## Resources to Learn More

- "Algorithmic Trading" by Ernest Chan
- QuantInsti courses
- YouTube: Sentdex, Part Time Larry
- Practice on paper first!
''',
      author: 'Ankit Sharma',
      category: 'Advanced Trading',
      level: 'Advanced',
      readTimeMinutes: 18,
      tags: ['algo-trading', 'automation', 'python', 'backtesting', 'advanced'],
      publishedAt: DateTime.now().subtract(const Duration(days: 14)),
      viewCount: 6540,
      likeCount: 478,
      isFeatured: false,
    ),
    BlogModel(
      id: 'blog-14',
      title: 'Trading Psychology: Mastering Your Mind for Market Success',
      summary: 'The mental game of trading is often more important than strategy. Learn to control emotions.',
      content: '''
# Trading Psychology: Mastering Your Mind

Your biggest enemy in trading isn't the market—it's yourself.

## Why Psychology Matters

Studies show:
- 90% of traders fail
- Most failures are psychological, not strategic
- Same strategy, different results based on execution

## Common Psychological Traps

### 1. Fear of Missing Out (FOMO)
**Symptoms:**
- Chasing stocks after big moves
- Entering without proper analysis
- Increasing position size in winning streaks

**Solution:**
- Stick to your watchlist
- If you miss a trade, wait for next setup
- Remember: There's always another opportunity

### 2. Fear of Loss
**Symptoms:**
- Moving stop-loss to avoid being stopped out
- Hesitating to enter valid setups
- Closing winners too early

**Solution:**
- Accept that losses are part of trading
- Define risk before entry
- Trust your system

### 3. Revenge Trading
**Symptoms:**
- Trading immediately after a loss
- Increasing size to "make back" losses
- Abandoning strategy

**Solution:**
- Take a break after losses
- Have a daily loss limit
- Journal your emotions

### 4. Overconfidence
**Symptoms:**
- Taking bigger risks after wins
- Ignoring risk management
- Thinking you've "figured it out"

**Solution:**
- Treat every trade the same
- Stick to position sizing rules
- Review losses, not just wins

### 5. Analysis Paralysis
**Symptoms:**
- Too many indicators
- Can't pull the trigger
- Always waiting for "better" setup

**Solution:**
- Simplify your strategy
- Set clear entry criteria
- Accept imperfection

## The Trading Mindset

### Think in Probabilities
- No trade is guaranteed
- You're playing the edge over many trades
- Focus on process, not outcome

### Embrace Uncertainty
- Markets are unpredictable
- Your job is to manage risk
- Accept what you can't control

### Be Process-Oriented
- Follow your rules
- Execute your plan
- Results will follow

## Building Mental Discipline

### 1. Create a Trading Plan
Write down:
- Entry criteria
- Exit criteria
- Position sizing rules
- Daily routine

### 2. Keep a Trading Journal

Record:
- Date and time
- Setup type
- Entry/exit prices
- Result
- **Emotional state**
- **Lessons learned**

### 3. Pre-Trade Checklist
Before every trade, verify:
- [ ] Does this fit my strategy?
- [ ] Is risk defined?
- [ ] Am I emotionally stable?
- [ ] Is this a good R:R?

### 4. Post-Trade Review
After every trade, ask:
- Did I follow my rules?
- What did I do well?
- What can I improve?

## Managing Emotions

### During Winning Streaks
- Don't increase size dramatically
- Stay humble
- Book some profits
- Remember: Drawdowns will come

### During Losing Streaks
- Reduce position size
- Take a break if needed
- Review your process
- Don't abandon strategy prematurely

### Daily Routine
**Morning:**
- Market review
- Set alerts for setups
- Mental preparation

**Trading Hours:**
- Follow the plan
- Note emotions in journal
- Take breaks

**Evening:**
- Review trades
- Update journal
- Prepare for tomorrow

## Techniques for Mental Control

### Breathing Exercises
- 4-7-8 technique
- Box breathing
- Before entering trades

### Visualization
- Imagine executing perfectly
- Visualize handling losses calmly
- See yourself as disciplined trader

### Positive Self-Talk
- "I follow my rules"
- "Losses are part of the game"
- "I trust my process"

## Signs You Need a Break

- Checking P&L constantly
- Losing sleep over trades
- Trading more than planned
- Feeling anxious or stressed
- Breaking rules repeatedly

**Take 1-2 weeks off. The market will be there.**

## Key Takeaways

1. Psychology separates winners from losers
2. Have a written trading plan
3. Keep a detailed journal
4. Manage emotions proactively
5. Take breaks when needed
6. Focus on process, not profits
7. Accept losses as business expenses

**"The goal of a successful trader is to make the best trades. Money is secondary." - Alexander Elder**
''',
      author: 'Dr. Meera Krishnan',
      category: 'Psychology',
      level: 'Advanced',
      readTimeMinutes: 14,
      tags: ['psychology', 'mindset', 'emotions', 'discipline', 'advanced'],
      publishedAt: DateTime.now().subtract(const Duration(days: 1)),
      viewCount: 9870,
      likeCount: 823,
      isFeatured: true,
    ),
    BlogModel(
      id: 'blog-15',
      title: 'Portfolio Construction: Building a Diversified Investment Portfolio',
      summary: 'Learn how to construct and manage a well-diversified portfolio for long-term wealth creation.',
      content: '''
# Portfolio Construction: Building a Diversified Portfolio

A well-constructed portfolio is your foundation for long-term wealth creation.

## Principles of Portfolio Construction

### 1. Diversification
Don't put all eggs in one basket.

**Diversify across:**
- Asset classes (equity, debt, gold)
- Sectors (IT, banking, pharma, etc.)
- Market caps (large, mid, small)
- Geographies (domestic, international)

### 2. Asset Allocation
Decide how much in each asset class.

**Factors to consider:**
- Age and risk tolerance
- Investment horizon
- Financial goals
- Income stability

### 3. Risk-Return Tradeoff
Higher returns = Higher risk

**Risk spectrum:**
Savings Account < FD < Debt Funds < Balanced Funds < Equity < Small Caps

## Asset Allocation Models

### Conservative (Low Risk)
| Asset | Allocation |
|-------|------------|
| Equity | 20-30% |
| Debt | 50-60% |
| Gold | 10-15% |
| Cash | 5-10% |

**Suitable for:** Near retirement, low risk tolerance

### Balanced (Moderate Risk)
| Asset | Allocation |
|-------|------------|
| Equity | 50-60% |
| Debt | 30-40% |
| Gold | 5-10% |
| Cash | 5% |

**Suitable for:** Middle-aged, moderate risk tolerance

### Aggressive (High Risk)
| Asset | Allocation |
|-------|------------|
| Equity | 70-80% |
| Debt | 10-20% |
| Gold | 5-10% |
| Cash | 5% |

**Suitable for:** Young investors, high risk tolerance

## Equity Portfolio Construction

### By Market Cap

**Recommended mix:**
- Large Cap: 50-60%
- Mid Cap: 25-30%
- Small Cap: 10-20%

### By Sector

**Don't exceed 20-25% in any single sector**

Core sectors to include:
- Banking & Finance
- IT Services
- Consumer Goods
- Pharma/Healthcare
- Infrastructure

### Number of Stocks
- Too few: Concentrated risk
- Too many: Diluted returns

**Recommended: 15-25 stocks**

## Stock Selection Framework

### Quality Filters
- Market cap > ₹5,000 Cr
- Consistent profit growth
- ROE > 15%
- Debt-to-equity < 1
- Positive operating cash flow

### Valuation Checks
- P/E relative to industry
- P/B within reasonable range
- PEG ratio < 2

### Management Quality
- Promoter holding > 50%
- Low pledged shares
- Good corporate governance

## Portfolio Weighting Methods

### 1. Equal Weight
- Same amount in each stock
- Simple to implement
- Rebalance periodically

### 2. Market Cap Weight
- More in larger companies
- Mirrors index composition
- Lower turnover

### 3. Conviction-Based
- More in high-conviction picks
- Core-satellite approach
- Requires active management

## Core-Satellite Approach

**Core (60-70%):**
- Index funds or large-cap stocks
- Low cost, stable returns
- Buy and hold

**Satellite (30-40%):**
- Active picks
- Sector bets
- High-growth opportunities

## Rebalancing

### Why Rebalance?
- Maintain target allocation
- Book profits from winners
- Buy more of losers (discipline)

### When to Rebalance?
**Time-based:** Every 6-12 months
**Threshold-based:** When allocation drifts >5%

### How to Rebalance?
1. Review current allocation
2. Compare to target
3. Sell overweight assets
4. Buy underweight assets

## Monitoring Your Portfolio

### Track These Metrics
- Total return vs benchmark
- Individual stock performance
- Sector allocation
- Dividend yield
- Portfolio beta

### Review Frequency
- Daily: Don't (except for traders)
- Weekly: Quick overview
- Monthly: Detailed review
- Quarterly: Rebalancing check
- Annually: Full portfolio review

## Common Mistakes

1. Over-diversification (50+ stocks)
2. Chasing past returns
3. Ignoring asset allocation
4. No rebalancing
5. Emotional decisions
6. Copying others blindly

## Tax-Efficient Investing

### Long-Term Capital Gains
- Hold > 1 year
- 10% tax above ₹1 lakh

### Strategies
- Harvest losses to offset gains
- Use ELSS for tax saving
- Hold long-term when possible

## Sample Portfolio (₹10 Lakh)

| Category | Allocation | Amount |
|----------|------------|--------|
| Large Cap Stocks | 40% | ₹4,00,000 |
| Mid Cap Stocks | 20% | ₹2,00,000 |
| Small Cap | 10% | ₹1,00,000 |
| Debt Funds | 20% | ₹2,00,000 |
| Gold | 10% | ₹1,00,000 |

**Start with your asset allocation, then select specific investments.**
''',
      author: 'Venkat Subramanian',
      category: 'Investing',
      level: 'Advanced',
      readTimeMinutes: 15,
      tags: ['portfolio', 'diversification', 'asset-allocation', 'investing'],
      publishedAt: DateTime.now().subtract(const Duration(days: 20)),
      viewCount: 7650,
      likeCount: 543,
      isFeatured: false,
    ),
  ];

  // Demo courses
  final List<CourseModel> _demoCourses = [
    CourseModel(
      id: '1',
      title: 'Stock Market Basics',
      description: 'Learn the fundamentals of stock market investing from scratch.',
      contentType: ContentType.video,
      difficulty: 'Beginner',
      durationMinutes: 120,
      enrolledCount: 15420,
      rating: 4.8,
      lessons: [
        LessonModel(id: '1-1', courseId: '1', title: 'What is Stock Market?', content: 'Introduction to stock markets and how they work.', orderIndex: 0, durationMinutes: 15),
        LessonModel(id: '1-2', courseId: '1', title: 'Types of Stocks', content: 'Learn about different types of stocks - common, preferred, blue-chip, penny stocks.', orderIndex: 1, durationMinutes: 20),
        LessonModel(id: '1-3', courseId: '1', title: 'Stock Exchanges in India', content: 'Overview of NSE, BSE, and how trading works.', orderIndex: 2, durationMinutes: 15),
        LessonModel(id: '1-4', courseId: '1', title: 'How to Open a Demat Account', content: 'Step-by-step guide to opening a trading account.', orderIndex: 3, durationMinutes: 20),
        LessonModel(id: '1-5', courseId: '1', title: 'Placing Your First Order', content: 'Learn to place buy and sell orders.', orderIndex: 4, durationMinutes: 25),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
    ),
    CourseModel(
      id: '2',
      title: 'Technical Analysis Masterclass',
      description: 'Master chart patterns, indicators, and price action trading.',
      contentType: ContentType.video,
      difficulty: 'Intermediate',
      durationMinutes: 300,
      enrolledCount: 8756,
      rating: 4.7,
      isPremium: true,
      lessons: [
        LessonModel(id: '2-1', courseId: '2', title: 'Introduction to Charts', content: 'Understanding candlestick, bar, and line charts.', orderIndex: 0, durationMinutes: 25),
        LessonModel(id: '2-2', courseId: '2', title: 'Support and Resistance', content: 'Identifying key price levels.', orderIndex: 1, durationMinutes: 30),
        LessonModel(id: '2-3', courseId: '2', title: 'Chart Patterns', content: 'Head & shoulders, double tops, triangles, and more.', orderIndex: 2, durationMinutes: 45),
        LessonModel(id: '2-4', courseId: '2', title: 'Moving Averages', content: 'SMA, EMA, and crossover strategies.', orderIndex: 3, durationMinutes: 35),
        LessonModel(id: '2-5', courseId: '2', title: 'RSI and MACD', content: 'Momentum indicators explained.', orderIndex: 4, durationMinutes: 40),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    ),
    CourseModel(
      id: '3',
      title: 'Fundamental Analysis',
      description: 'Learn to analyze company financials and value stocks.',
      contentType: ContentType.article,
      difficulty: 'Intermediate',
      durationMinutes: 180,
      enrolledCount: 6234,
      rating: 4.6,
      lessons: [
        LessonModel(id: '3-1', courseId: '3', title: 'Reading Financial Statements', content: 'Balance sheet, P&L, and cash flow analysis.', orderIndex: 0, durationMinutes: 30),
        LessonModel(id: '3-2', courseId: '3', title: 'Key Ratios', content: 'P/E, P/B, ROE, ROCE, and debt ratios.', orderIndex: 1, durationMinutes: 35),
        LessonModel(id: '3-3', courseId: '3', title: 'Valuation Methods', content: 'DCF, comparable analysis, and asset-based valuation.', orderIndex: 2, durationMinutes: 40),
        LessonModel(id: '3-4', courseId: '3', title: 'Industry Analysis', content: 'Understanding sector dynamics and competitive advantage.', orderIndex: 3, durationMinutes: 35),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
    ),
    CourseModel(
      id: '4',
      title: 'Intraday Trading Strategies',
      description: 'Learn profitable day trading strategies and risk management.',
      contentType: ContentType.video,
      difficulty: 'Advanced',
      durationMinutes: 240,
      enrolledCount: 4521,
      rating: 4.5,
      isPremium: true,
      lessons: [
        LessonModel(id: '4-1', courseId: '4', title: 'Intraday vs Delivery', content: 'Difference and when to use each.', orderIndex: 0, durationMinutes: 20),
        LessonModel(id: '4-2', courseId: '4', title: 'Stock Selection', content: 'How to pick stocks for intraday trading.', orderIndex: 1, durationMinutes: 30),
        LessonModel(id: '4-3', courseId: '4', title: 'Entry and Exit Rules', content: 'Timing your trades for maximum profit.', orderIndex: 2, durationMinutes: 35),
        LessonModel(id: '4-4', courseId: '4', title: 'Risk Management', content: 'Position sizing and stop-loss strategies.', orderIndex: 3, durationMinutes: 40),
        LessonModel(id: '4-5', courseId: '4', title: 'Trading Psychology', content: 'Managing emotions and staying disciplined.', orderIndex: 4, durationMinutes: 30),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    CourseModel(
      id: '5',
      title: 'Options Trading for Beginners',
      description: 'Understanding options, Greeks, and basic strategies.',
      contentType: ContentType.video,
      difficulty: 'Advanced',
      durationMinutes: 280,
      enrolledCount: 3892,
      rating: 4.4,
      isPremium: true,
      lessons: [
        LessonModel(id: '5-1', courseId: '5', title: 'What are Options?', content: 'Call and Put options explained.', orderIndex: 0, durationMinutes: 25),
        LessonModel(id: '5-2', courseId: '5', title: 'Options Terminology', content: 'Strike price, premium, expiry, ITM/ATM/OTM.', orderIndex: 1, durationMinutes: 30),
        LessonModel(id: '5-3', courseId: '5', title: 'Option Greeks', content: 'Delta, Gamma, Theta, Vega explained.', orderIndex: 2, durationMinutes: 40),
        LessonModel(id: '5-4', courseId: '5', title: 'Basic Strategies', content: 'Covered calls, protective puts, spreads.', orderIndex: 3, durationMinutes: 45),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
  ];

  // Demo daily tips
  final List<DailyTipModel> _demoTips = [
    DailyTipModel(id: '1', title: 'Diversification', content: 'Never put all your eggs in one basket. Spread your investments across different sectors and asset classes.', category: 'Risk Management', date: DateTime.now()),
    DailyTipModel(id: '2', title: 'Start with Blue Chips', content: 'As a beginner, start with large-cap, well-established companies before moving to mid and small caps.', category: 'Investing', date: DateTime.now().subtract(const Duration(days: 1))),
    DailyTipModel(id: '3', title: 'Set Stop Losses', content: 'Always set a stop-loss for every trade to limit your potential losses. Never trade without a exit plan.', category: 'Trading', date: DateTime.now().subtract(const Duration(days: 2))),
    DailyTipModel(id: '4', title: 'Avoid FOMO', content: 'Fear of Missing Out can lead to bad investment decisions. Stick to your investment thesis and avoid chasing momentum.', category: 'Psychology', date: DateTime.now().subtract(const Duration(days: 3))),
    DailyTipModel(id: '5', title: 'Regular Investing', content: 'SIP (Systematic Investment Plan) helps you invest regularly and benefits from rupee cost averaging.', category: 'Investing', date: DateTime.now().subtract(const Duration(days: 4))),
  ];

  // Get all courses
  Future<List<CourseModel>> getAllCourses() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _demoCourses;
  }

  // Get course by ID
  Future<CourseModel?> getCourseById(String courseId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _demoCourses.firstWhere((course) => course.id == courseId);
    } catch (e) {
      return null;
    }
  }

  // Get courses by difficulty
  Future<List<CourseModel>> getCoursesByDifficulty(String difficulty) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _demoCourses
        .where((course) => course.difficulty == difficulty)
        .toList();
  }

  // Get free courses
  Future<List<CourseModel>> getFreeCourses() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _demoCourses.where((course) => !course.isPremium).toList();
  }

  // Get premium courses
  Future<List<CourseModel>> getPremiumCourses() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _demoCourses.where((course) => course.isPremium).toList();
  }

  // Get daily tips
  Future<List<DailyTipModel>> getDailyTips({int limit = 5}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _demoTips.take(limit).toList();
  }

  // Get today's tip
  Future<DailyTipModel?> getTodaysTip() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _demoTips.first;
  }

  // Search courses
  Future<List<CourseModel>> searchCourses(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final lowerQuery = query.toLowerCase();
    return _demoCourses.where((course) {
      return course.title.toLowerCase().contains(lowerQuery) ||
          course.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Generate demo quiz
  Future<QuizModel> getQuiz(String courseId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return QuizModel(
      id: 'quiz-$courseId',
      courseId: courseId,
      title: 'Course Quiz',
      questions: [
        QuizQuestion(
          id: 'q1',
          question: 'What does P/E ratio stand for?',
          options: ['Price to Earnings', 'Profit to Equity', 'Price to Equity', 'Profit to Earnings'],
          correctOptionIndex: 0,
          explanation: 'P/E ratio is Price to Earnings ratio, calculated by dividing market price by EPS.',
        ),
        QuizQuestion(
          id: 'q2',
          question: 'Which indicator shows overbought/oversold conditions?',
          options: ['MACD', 'RSI', 'Moving Average', 'Bollinger Bands'],
          correctOptionIndex: 1,
          explanation: 'RSI (Relative Strength Index) shows overbought (>70) and oversold (<30) conditions.',
        ),
        QuizQuestion(
          id: 'q3',
          question: 'What is a bullish candlestick pattern?',
          options: ['Hanging Man', 'Shooting Star', 'Hammer', 'Evening Star'],
          correctOptionIndex: 2,
          explanation: 'Hammer is a bullish reversal pattern that appears at the bottom of a downtrend.',
        ),
      ],
    );
  }

  // ============ BLOG METHODS ============

  // Get all blogs
  Future<List<BlogModel>> getAllBlogs() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _demoBlogs;
  }

  // Get featured blogs
  Future<List<BlogModel>> getFeaturedBlogs() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _demoBlogs.where((blog) => blog.isFeatured).toList();
  }

  // Get blog by ID
  Future<BlogModel?> getBlogById(String blogId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _demoBlogs.firstWhere((blog) => blog.id == blogId);
    } catch (e) {
      return null;
    }
  }

  // Get blogs by level
  Future<List<BlogModel>> getBlogsByLevel(String level) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _demoBlogs.where((blog) => blog.level == level).toList();
  }

  // Get blogs by category
  Future<List<BlogModel>> getBlogsByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _demoBlogs.where((blog) => blog.category == category).toList();
  }

  // Search blogs
  Future<List<BlogModel>> searchBlogs(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final lowerQuery = query.toLowerCase();
    return _demoBlogs.where((blog) {
      return blog.title.toLowerCase().contains(lowerQuery) ||
          blog.summary.toLowerCase().contains(lowerQuery) ||
          blog.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  // Get all blog categories
  List<String> getBlogCategories() {
    return _demoBlogs.map((blog) => blog.category).toSet().toList();
  }
}
