
dishes = ['Tea-Smoked Garlic Chicken',
            'Fire-Roasted Pepper & Mango Lamb',
            'Roasted Beets & Orange Tuna',
            'Pickled Sugar Pasta',
            'Pan-Fried Confit of Rice',
            'Gentle-Fried Blueberry & Mushroom Taco',
            'Melon and Cranberry Jam',
            'Mandarin and Banana Toast',
            'Kiwi Whip',
            'Lime Pastry']


for i in range(10):
    dish_id = i + 1
    dish = dishes[i]

    print("{}|{}".format(dish_id, dish))