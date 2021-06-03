Map getPorfolio() {
  List<Map> portfolioList = [
    {
      "name": "Apple Inc",
      "symbol": "AAPL",
      "totalQuantity": 20.00,
      "equityValue": 2500.00,
      "pricePerShare": 125.00,
    },
    {
      "name": "Tesla Motors",
      "symbol": "TSLA",
      "totalQuantity": 5.00,
      "equityValue": 3000.00,
      "pricePerShare": 600.00,
    },
    {
      "name": "Amazon Corp",
      "symbol": "AMZN",
      "totalQuantity": 1.39,
      "equityValue": 4500.00,
      "pricePerShare": 150.00,
    },
    {
      "name": "Berkshire Hath",
      "symbol": "BRKA",
      "totalQuantity": 0.00,
      "equityValue": 0.00,
      "pricePerShare": 0.00,
    },
    {
      "name": "Microsoft Corp",
      "symbol": "MSFT",
      "totalQuantity": 0.00,
      "equityValue": 0.00,
      "pricePerShare": 0.00,
    },
    {
      "name": "Nvidia Corp",
      "symbol": "NVDA",
      "totalQuantity": 0.0,
      "equityValue": 0.00,
      "pricePerShare": 0.00,
    },
  ];

  Map portfolio = {
    "portfolioValue": 10000,
    "portfolioPositions": portfolioList,
  };

  return portfolio;
}
