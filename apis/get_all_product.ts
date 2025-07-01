function paginate(array, page = 1, limit = 10) {
  const total = array.length;
  const totalPages = Math.ceil(total / limit);
  const start = (page - 1) * limit;
  const end = start + limit;
  const data = array.slice(start, end);

  return {
    data,
    page,
    limit,
    total,
    totalPages,
  };
}

// Route chung cho 3 loại dữ liệu
app.get("/api/:type", (req, res) => {
  const { type } = req.params;
  let { page, limit } = req.query;

  page = parseInt(page) || 1;
  limit = parseInt(limit) || 10;

  const collection = db[type];

  if (!collection) {
    return res.status(404).json({ error: "Resource not found" });
  }

  const result = paginate(collection, page, limit);
  res.json(result);
});
