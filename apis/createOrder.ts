import db from "./db.json"; // chỉ dùng để đọc
import fs from "fs";
import path from "path";
import jwt from "jsonwebtoken";
import { Request, Response } from "express";

const SECRET_KEY = "your_jwt_secret"; // nên để trong .env

interface CartItem {
  productId: string;
  quantity: number;
}

interface Order {
  id: string;
  userId: string;
  items: CartItem[];
  createdAt: string;
}

// Trả về đường dẫn file thật để ghi
const dbFilePath = path.join(__dirname, "./db.json");

// Load lại dữ liệu mỗi lần xử lý
function loadDB() {
  const raw = fs.readFileSync(dbFilePath, "utf-8");
  return JSON.parse(raw);
}

// Ghi đè dữ liệu
function saveDB(newDb: any) {
  fs.writeFileSync(dbFilePath, JSON.stringify(newDb, null, 2), "utf-8");
}

// Express route handler
export const createOrderHandler = (req: Request, res: Response) => {
  try {
    const cartData: CartItem[] = req.body.cartData;
    const token = req.headers.authorization?.split(" ")[1];

    if (!token) {
      return res.status(401).json({ error: "Missing token" });
    }

    let decoded: any;
    try {
      decoded = jwt.verify(token, SECRET_KEY);
    } catch (err) {
      return res.status(401).json({ error: "Invalid token" });
    }

    const userId = decoded.userId;
    const dbLive = loadDB();

    const userExists = dbLive.users.some((user) => user.id === userId);
    if (!userExists) {
      return res.status(404).json({ error: "User not found" });
    }

    const success: CartItem[] = [];
    const failed: CartItem[] = [];

    for (const item of cartData) {
      const product = dbLive.products.find((p) => p.id === item.productId);
      if (!product || item.quantity > product.stock) {
        failed.push(item);
      } else {
        success.push(item);
      }
    }

    let orderId: string | null = null;

    if (success.length > 0) {
      // Trừ stock
      for (const item of success) {
        const product = dbLive.products.find((p) => p.id === item.productId);
        if (product) product.stock -= item.quantity;
      }

      // Tạo order
      orderId = `order_${Date.now()}`;
      const newOrder: Order = {
        id: orderId,
        userId,
        items: success,
        createdAt: new Date().toISOString(),
      };

      dbLive.orders.push(newOrder);

      // Lưu lại
      saveDB(dbLive);
    }

    return res.status(200).json({
      success,
      failed,
      orderId,
    });
  } catch (error: any) {
    return res
      .status(500)
      .json({ error: error.message || "Internal server error" });
  }
};
