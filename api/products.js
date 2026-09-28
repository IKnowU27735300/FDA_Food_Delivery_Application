const mysql = require('mysql2/promise');

const FALLBACK_PRODUCTS = [
  { id: 1, name: "Classic Denim Jacket", description: "A timeless utility denim jacket crafted from durable, premium cotton denim. Features chest button pockets, welt side pockets, and adjustable tab buttons at the back waist. Perfect for casual layering.", price: 1899.00, image_url: "images/denim_jacket.jpg", category_id: 1, variants: [{size: "S", stock: 12, price: 1699}, {size: "M", stock: 25, price: 1899}, {size: "L", stock: 18, price: 1999}, {size: "XL", stock: 8, price: 2199}] },
  { id: 2, name: "Slim Fit Linen Shirt", description: "Lightweight and breathable slim fit shirt woven from pure, textured organic flax linen. Designed with a clean band collar, button-up front, and curved shirttail hem. Keeps you cool and comfortable all day.", price: 1299.00, image_url: "images/linen_shirt.jpg", category_id: 1, variants: [{size: "S", stock: 15, price: 1199}, {size: "M", stock: 30, price: 1299}, {size: "L", stock: 20, price: 1399}, {size: "XL", stock: 10, price: 1499}] },
  { id: 3, name: "Floral Summer Dress", description: "A beautiful, flowing midi dress patterned with vibrant wildflower blooms. Featuring a structured corset bodice, delicate tie-up shoulder straps, and a flared tier skirt with a subtle side slit.", price: 1599.00, image_url: "images/summer_dress.jpg", category_id: 2, variants: [{size: "S", stock: 8, price: 1499}, {size: "M", stock: 18, price: 1599}, {size: "L", stock: 12, price: 1699}] },
  { id: 4, name: "Pleated Midi Skirt", description: "An elegant pleated skirt falling gracefully to a midi length. Fabricated in lightweight, satin-finish crepe with a flexible elasticized waistband. Moves beautifully with every step.", price: 1199.00, image_url: "images/midi_skirt.jpg", category_id: 2, variants: [{size: "S", stock: 10, price: 1099}, {size: "M", stock: 20, price: 1199}, {size: "L", stock: 15, price: 1299}] },
  { id: 5, name: "Leather Crossbody Bag", description: "A sleek, compact crossbody bag handcrafted from rich full-grain calfskin leather. Accented with brass hardware, featuring a secure zipper top, fabric-lined interior, and an adjustable shoulder strap.", price: 2499.00, image_url: "images/crossbody_bag.jpg", category_id: 3, variants: [{size: "One Size", stock: 25, price: 2499}] },
  { id: 6, name: "Classic Aviator Sunglasses", description: "Unisex aviator sunglasses built with a slim gold-toned metal frame, double bridge bar, and protective dark grey polarized lenses. Offers 100% UV protection and classic vintage vibes.", price: 699.00, image_url: "images/aviator_glasses.jpg", category_id: 3, variants: [{size: "One Size", stock: 40, price: 699}] },
  { id: 7, name: "Classic Crewneck T-Shirt", description: "A premium crewneck t-shirt made from 100% combed cotton. Exceptionally soft, durable, and tailored for a perfect fit.", price: 599.00, image_url: "images/mens_tshirt.png", category_id: 1, variants: [{size: "S", stock: 30, price: 499}, {size: "M", stock: 50, price: 599}, {size: "L", stock: 40, price: 649}, {size: "XL", stock: 20, price: 699}] },
  { id: 8, name: "Elegant Formal Dress Combo", description: "A sophisticated formal ensemble including a tailored blazer and matching trousers. Crafted from premium stretch-blend fabric for all-day comfort and sharp style.", price: 2999.00, image_url: "images/womens_formal_dress_combo.png", category_id: 2, variants: [{size: "S", stock: 10, price: 2899}, {size: "M", stock: 15, price: 2999}, {size: "L", stock: 12, price: 3099}] },
  { id: 9, name: "Men's Chronograph Leather Watch", description: "A luxury men's chronograph watch featuring a genuine leather strap, water-resistant stainless steel casing, and precise quartz movement.", price: 3499.00, image_url: "images/mens_watch.png", category_id: 3, variants: [{size: "One Size", stock: 15, price: 3499}] },
  { id: 10, name: "Women's Rose Gold Mesh Watch", description: "An elegant women's watch with a sleek rose gold mesh strap, minimalist dial, and scratch-resistant sapphire crystal glass.", price: 3299.00, image_url: "images/womens_watch.png", category_id: 3, variants: [{size: "One Size", stock: 20, price: 3299}] },
  { id: 11, name: "Silver Pendant & Necklace Combo", description: "A beautiful layered necklace set for women featuring fine sterling silver chains and elegant minimalist pendants.", price: 1499.00, image_url: "images/womens_necklace_combo.png", category_id: 3, variants: [{size: "One Size", stock: 25, price: 1499}] },
  { id: 12, name: "Men's Titanium Stud Earpieces", description: "Sleek and modern titanium stud earpieces designed for men. Features a matte finish and secure screw-back design.", price: 499.00, image_url: "images/mens_earpieces.png", category_id: 3, variants: [{size: "One Size", stock: 30, price: 499}] },
  { id: 13, name: "Women's Pearl Hoop Earpieces", description: "Charming hoop earpieces adorned with freshwater cultured pearls. Perfect for adding a touch of elegance to any outfit.", price: 599.00, image_url: "images/womens_earpieces.png", category_id: 3, variants: [{size: "One Size", stock: 25, price: 599}] },
  { id: 14, name: "Men's Classic Charcoal Formal Trousers", description: "Tailored slim-fit charcoal formal trousers crafted from a premium wrinkle-resistant poly-viscose blend. Featuring a clean flat-front design, side pockets, and double-welt back pockets.", price: 1499.00, image_url: "images/mens_formal_pants.png", category_id: 1, variants: [{size: "S", stock: 15, price: 1399}, {size: "M", stock: 20, price: 1499}, {size: "L", stock: 15, price: 1599}] },
  { id: 15, name: "Men's Classic Indigo Jeans", description: "Classic straight-fit jeans cut from durable, mid-weight cotton denim with a vintage indigo wash. Features classic five-pocket styling, contrast stitching, and a metal button closure.", price: 1699.00, image_url: "images/mens_jeans.png", category_id: 1, variants: [{size: "S", stock: 20, price: 1599}, {size: "M", stock: 25, price: 1699}, {size: "L", stock: 20, price: 1799}] },
  { id: 16, name: "Men's Comfort Fit Casual Chinos", description: "Everyday slim chinos constructed from soft, stretch-twill cotton fabric. Designed with a button-through waistband, slanted side pockets, and coin pocket. Perfect for smart-casual wear.", price: 1299.00, image_url: "images/mens_casual_pants.png", category_id: 1, variants: [{size: "S", stock: 15, price: 1199}, {size: "M", stock: 25, price: 1299}, {size: "L", stock: 20, price: 1399}] },
  { id: 17, name: "Men's Graphic Casual T-Shirt", description: "A premium crewneck t-shirt featuring a modern geometric print on the chest. Knit from soft, breathable combed cotton for relaxed weekend comfort.", price: 699.00, image_url: "images/mens_casual_tshirt_v2.png", category_id: 1, variants: [{size: "S", stock: 30, price: 599}, {size: "M", stock: 40, price: 699}, {size: "L", stock: 35, price: 749}, {size: "XL", stock: 15, price: 799}] },
  { id: 18, name: "Men's Premium White Formal Shirt", description: "A crisp, classic white dress shirt woven from 100% fine cotton with an easy-iron finish. Features a spread collar, button cuffs, and structured back yoke.", price: 1599.00, image_url: "images/mens_formal_shirt.png", category_id: 1, variants: [{size: "S", stock: 15, price: 1499}, {size: "M", stock: 25, price: 1599}, {size: "L", stock: 20, price: 1699}] },
  { id: 19, name: "Men's Vintage Plaid Casual Shirt", description: "A cozy and rugged flannel button-down shirt featuring a vintage red and black plaid pattern. Accented with dual chest patch pockets and buttoned cuffs.", price: 1399.00, image_url: "images/mens_casual_shirt.png", category_id: 1, variants: [{size: "S", stock: 20, price: 1299}, {size: "M", stock: 30, price: 1399}, {size: "L", stock: 25, price: 1499}] },
  { id: 20, name: "Women's High-Waist Formal Trousers", description: "Elegant high-rise formal trousers with a sophisticated wide-leg silhouette. Fabricated from premium crepe that drapes beautifully. Features side zip closure and clean welt pockets.", price: 1899.00, image_url: "images/womens_formal_pants.png", category_id: 2, variants: [{size: "S", stock: 12, price: 1799}, {size: "M", stock: 18, price: 1899}, {size: "L", stock: 15, price: 1999}] },
  { id: 21, name: "Women's Classic Skinny Jeans", description: "An ultra-flattering skinny jean engineered from high-stretch denim that moves with you while retaining its shape. Styled with a classic five-pocket setup in a vintage blue wash.", price: 1599.00, image_url: "images/womens_jeans.png", category_id: 2, variants: [{size: "S", stock: 20, price: 1499}, {size: "M", stock: 30, price: 1599}, {size: "L", stock: 25, price: 1699}] },
  { id: 22, name: "Women's Relaxed Fit Casual Pants", description: "Comfortable and light casual trousers crafted from a soft linen-cotton blend. Features an elasticated drawstring waist, relaxed tapered leg, and side slip pockets.", price: 1299.00, image_url: "images/womens_casual_pants.png", category_id: 2, variants: [{size: "S", stock: 15, price: 1199}, {size: "M", stock: 25, price: 1299}, {size: "L", stock: 20, price: 1399}] },
  { id: 23, name: "Women's V-Neck Casual T-Shirt", description: "A basic V-neck casual t-shirt made of soft modal-cotton jersey. Features a relaxed silhouette, short sleeves, and a curved hem.", price: 699.00, image_url: "images/womens_casual_tshirt.png", category_id: 2, variants: [{size: "S", stock: 25, price: 599}, {size: "M", stock: 35, price: 699}, {size: "L", stock: 30, price: 749}] },
  { id: 24, name: "Women's Silk Formal Blouse", description: "A luxurious and smooth long-sleeve formal blouse styled in pure ivory silk. Detailed with a elegant band collar and covered front button placket.", price: 2799.00, image_url: "images/womens_formal_shirt_v2.png", category_id: 2, variants: [{size: "S", stock: 10, price: 2699}, {size: "M", stock: 15, price: 2799}, {size: "L", stock: 12, price: 2899}] },
  { id: 25, name: "Women's Oversized Linen Casual Shirt", description: "A lightweight, breathable oversized casual button-up shirt in soft peach linen. Perfect for layering over tank tops on warm days.", price: 1499.00, image_url: "images/womens_casual_shirt.png", category_id: 2, variants: [{size: "S", stock: 15, price: 1399}, {size: "M", stock: 20, price: 1499}, {size: "L", stock: 15, price: 1599}] },
  { id: 26, name: "Soft Cuddly Princess Doll", description: "A beautiful, soft fabric princess doll dressed in a lovely pink satin gown. Features stitched facial details, yarn hair, and is completely child-safe.", price: 799.00, image_url: "images/kids_doll.png", category_id: 4, variants: [{size: "One Size", stock: 25, price: 799}] },
  { id: 27, name: "Die-Cast Toy Race Car", description: "A high-speed die-cast metal toy race car in sporty red with working rubber tires, pull-back action, and openable doors. Designed for children 3+.", price: 499.00, image_url: "images/kids_car.png", category_id: 4, variants: [{size: "One Size", stock: 40, price: 499}] },
  { id: 28, name: "100-Piece Animal Kingdom Puzzle", description: "An educational 100-piece cardboard jigsaw puzzle featuring a vibrant forest animal illustration. Helps develop problem-solving skills and fine motor coordination.", price: 399.00, image_url: "images/kids_puzzle.png", category_id: 4, variants: [{size: "One Size", stock: 30, price: 399}] },
  { id: 29, name: "Classic Ludo Board Game Set", description: "A premium folding wooden Ludo board game set with high-quality wooden tokens and two dice. A classic family tabletop game for kids and adults alike.", price: 599.00, image_url: "images/kids_ludo.png", category_id: 4, variants: [{size: "One Size", stock: 20, price: 599}] },
  { id: 30, name: "Educational Building Blocks Set", description: "A creative set of 120 colorful plastic building blocks in various shapes and sizes. Stimulates imagination, spatial reasoning, and creative construction skills.", price: 999.00, image_url: "images/kids_toy_blocks.png", category_id: 4, variants: [{size: "One Size", stock: 35, price: 999}] },
  { id: 31, name: "Kid's Cotton Floral Summer Dress", description: "A lovely and airy kid's summer dress stitched from 100% breathable organic cotton. Featuring a bright yellow floral pattern and adjustable tie-up shoulder straps.", price: 899.00, image_url: "images/kids_dress_floral.png", category_id: 4, variants: [{size: "2-3Y", stock: 15, price: 799}, {size: "4-5Y", stock: 20, price: 899}, {size: "6-7Y", stock: 15, price: 999}] },
  { id: 32, name: "Kid's Denim Dungaree Combo", description: "A classic and durable kid's outfit featuring a washed denim dungaree skirt paired with a striped cotton short-sleeve tee. Perfect for active play.", price: 1199.00, image_url: "images/kids_dungaree.png", category_id: 4, variants: [{size: "2-3Y", stock: 12, price: 1099}, {size: "4-5Y", stock: 18, price: 1199}, {size: "6-7Y", stock: 12, price: 1299}] },
  { id: 33, name: "Kid's Cozy Dino Hoodie & Joggers", description: "A warm and playful outfit featuring a fleece hoodie with dinosaur spike details on the hood and matching elasticated joggers. Soft, cozy, and kid-approved.", price: 1299.00, image_url: "images/kids_dino_set.png", category_id: 4, variants: [{size: "2-3Y", stock: 10, price: 1199}, {size: "4-5Y", stock: 15, price: 1299}, {size: "6-7Y", stock: 12, price: 1399}] }
];

module.exports = async (req, res) => {
  res.setHeader('Content-Type', 'application/json');
  res.setHeader('Access-Control-Allow-Origin', '*');

  const { id, category, q } = req.query;

  // If a cloud database is provided, attempt connection; otherwise fallback gracefully
  if (process.env.DB_HOST && process.env.DB_USER) {
    try {
      const isTiDB = process.env.DB_HOST.includes('tidb') || process.env.DB_PORT === '4000';
      const connection = await mysql.createConnection({
        host: process.env.DB_HOST,
        port: parseInt(process.env.DB_PORT || '3306'),
        user: process.env.DB_USER,
        password: process.env.DB_PASSWORD || '',
        database: process.env.DB_NAME || 'tap_fashion_db',
        ssl: isTiDB ? { rejectUnauthorized: true } : false
      });

      if (id) {
        const [products] = await connection.execute('SELECT * FROM products WHERE id = ?', [id]);
        if (products.length > 0) {
          const [variants] = await connection.execute('SELECT * FROM product_variants WHERE product_id = ?', [id]);
          const p = products[0];
          p.variants = variants;
          await connection.end();
          return res.status(200).json(p);
        }
      } else {
        let sql = 'SELECT * FROM products WHERE 1=1';
        const params = [];
        if (category) {
          sql += ' AND category_id = ?';
          params.push(category);
        }
        if (q) {
          sql += ' AND (name LIKE ? OR description LIKE ?)';
          params.push(`%${q}%`, `%${q}%`);
        }
        const [rows] = await connection.execute(sql, params);
        await connection.end();
        return res.status(200).json(rows);
      }
      await connection.end();
    } catch (err) {
      console.warn('Database query error, falling back to cached catalog:', err.message);
    }
  }

  // Fallback catalog response
  if (id) {
    const prod = FALLBACK_PRODUCTS.find(p => p.id == id);
    if (!prod) return res.status(404).json({ error: 'Product not found' });
    return res.status(200).json(prod);
  }

  let list = FALLBACK_PRODUCTS;
  if (category) {
    list = list.filter(p => p.category_id == category);
  }
  if (q) {
    const query = q.toLowerCase();
    list = list.filter(p => p.name.toLowerCase().includes(query) || p.description.toLowerCase().includes(query));
  }

  return res.status(200).json(list);
};
