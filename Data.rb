class EducationGarfield < Scripting::CustomParser

  def solo_product(doc)
    opt = doc.xpath("//div[@class='product-item-detail-info-section']")
    name = opt.xpath('./@title').text
    p[NAME] = name + i.to_s
    price = doc.xpath('//meta[@itemprop="price"]/@content')
    if price.first
      p[PRICE] = price(price.first.value)
    end
    old_price = opt.xpath(".//@data-old-price")
    if old_price.first
      p[REGULAR_PRICE] = price(old_price.first.value)
    end
    stock = opt.xpath("//span[@class='available']")
    if stock.first
      p[STOCK] = stock.first.text == "В наличии" ? "In stock" : "Out of stock"
    end
    promo_name = opt.xpath(".//@data-discountstatus")
    if promo_name.first
      p[PROMO_NAME] = price.first.value != "" ? "Акция" : nil
    end
    sku = opt.xpath('./@data-art').text
    p[SKU] = sku != "" ? sku : nil
    p[KEY] = name + "1"
    return p
  end

  def multi_product(multi, prices)
    i = 0
    multi.each do |opt|
      name = opt.xpath('./@title').text
      p[NAME] += ", " + name
      p[PRICE] = price(prices[i].value)
      sku = opt.xpath('./@data-art').text
      p[SKU] = sku != "" ? sku : nil
      p[KEY] = name + i.to_s
      p[REGULAR_PRICE] = price(opt.xpath(".//@data-old-price").first.value)
      p[STOCK] = opt.xpath(".//@data-availstatus").first.value == "not_avail" ? "Out of stock" : "In stock"
      p[PROMO_NAME] = opt.xpath(".//@data-discountstatus").first.value != "" ? "Акция" : ""
      i += 1
    end
    return p
  end

  def parse(ctx)
    base = ctx.base_product
    doc = ctx.doc
    if base
      p = base.dup
      prices = doc.xpath('//meta[@itemprop="price"]/@content')
      multi = doc.xpath("//div[@class='product-item-detail-info-section']//ul[contains(@class, 'product-item-scu-item-list item_prop_list')]//li")
      if multi.first
        p = multi_product(multi, prices)
        ctx.add_product(p)
      end
    else
      p = solo_product(doc)
      ctx.add_product(p)
    end
    !ctx.products.empty?
  end
end
