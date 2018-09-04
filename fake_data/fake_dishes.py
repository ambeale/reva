
dishes = ['Fried chicken',
            'Pad thai',
            'Crab fried rice',
            'Papaya salad',
            'Short rib noodle soup',
            'Thai tea',
            'Pad see ew',
            'Red curry',
            'Spring rolls',
            'Panang curry']


for i in range(10):
    dish_id = i + 1
    dish = dishes[i]

    print("{}|{}".format(dish_id, dish))