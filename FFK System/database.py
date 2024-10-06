#!/usr/bin/env python3
import psycopg2
#####################################################
##  Database Connection
#####################################################

'''
Connect to the database using the connection string
'''

current_user_id = None


class menuitem():
    menuitem_id = ""
    name = ""
    description = ""
    category = ""
    coffeeoption = ""
    price = ""
    reviewdate = ""
    reviewer = ""
    def __init__(self, menu):
        self.menuitem_id = menu[0]
        self.name = menu[1]
        self.description = menu[2]
        self.category = menu[3]
        self.coffeeoption = menu[4]
        self.price = menu[5]
        self.reviewdate = menu[6]
        self.reviewer = menu[7]

def openConnection():
    # connection parameters - ENTER YOUR LOGIN AND PASSWORD HERE
    userid = "y24s1c9120_howu0747"
    passwd = "5VhrHjNq"
    myHost = "awsprddbs4836.shared.sydney.edu.au"

    # Create a connection to the database
    conn = None
    try:
        # Parses the config file and connects using the connect string
        conn = psycopg2.connect(database=userid,
                                    user=userid,
                                    password=passwd,
                                    host=myHost)
    except psycopg2.Error as sqle:
        print("psycopg2.Error : " + sqle.pgerror)
    
    # return the connection to use
    return conn

'''
Validate staff based on username and password
'''
def checkStaffLogin(staffID, password):
    cursor = openConnection().cursor()
    try:
        SqlSentence = "Select * from staff where staffId = %s and password = %s;"
        cursor.execute(SqlSentence, [staffID, password])
        result = cursor.fetchone()
        cursor.close()
        return result
    except psycopg2.Error as e:
        print("Connecting has problem")
        print(e)
        return []
    finally:
        cursor.close()
    


'''
List all the associated menu items in the database by staff
'''
def findMenuItemsByStaff(staffID):
    result = []
    cursor = openConnection().cursor()
    try:
        SqlSentence = """
            select menuitemid as menuitem_id, name , coalesce(description, '') as description, coalesce(concat_ws('|', c1.categoryname, c2.categoryname, c3.categoryname)) as category, coalesce(concat_ws(' - ',coffeetypename,milkkindname), '') as coffeeoption, price, coalesce(to_char(reviewdate :: date,'dd-mm-yyyy'), '') as reviewdate, coalesce(concat_ws(' ', firstname, lastname), '') as reviewer 
            from menuitem mi left outer join coffeetype ct on (mi.coffeetype = ct.coffeetypeid) left outer join milkkind mk on (mi.milkkind = mk.milkkindid) join staff on (mi.reviewer = staffid) left outer join category c1 on (categoryone = c1.categoryid) left outer join category c2 on (categorytwo = c2.categoryid) left outer join category c3 on (categorythree = c3.categoryid) 
            where reviewer = %s 
            order by mi.reviewdate asc nulls first, description asc nulls first, price desc;
        """
        cursor.execute(SqlSentence, [staffID])
        temp = cursor.fetchall()
        for i in temp:
            result.append(menuitem(i))
        cursor.close()
        return result
    except psycopg2.Error as e:
        print("Connecting has problem")
        print(e)
        return []
    finally:
        cursor.close()


'''
Find a list of menu items based on the searchString provided as parameter
See assignment description for search specification
'''

def findMenuItemsByCriteria(searchString):
    conn = openConnection()
    result = []
    if conn == None:
        print("Error: connection fail")
        return []
    cur = conn.cursor()
    try:
        query = """
            select menuitemid as menuitem_id, name , coalesce(description, '') as description, coalesce(concat_ws('|', c1.categoryname, c2.categoryname, c3.categoryname)) as category, coalesce(concat_ws(' - ',coffeetypename,milkkindname), '') as coffeeoption, price, coalesce(to_char(reviewdate :: date,'dd-mm-yyyy'), '') as reviewdate, coalesce(concat_ws(' ', firstname, lastname), '') as reviewer
            from menuitem mi left join coffeetype ct on (mi.coffeetype = ct.coffeetypeid) left join category c1 on (mi.categoryone = c1.categoryid) left join category c2 on (mi.categorytwo = c2.categoryid) left join category c3 on (mi.categorythree = c3.categoryid) left join milkkind on (milkkind = milkkindid) left join staff on (reviewer = staffid)
            where (name ilike ('%%' || %s || '%%')
            or description ilike ('%%' || %s || '%%')
            or c1.categoryname ilike ('%%' || %s || '%%')
            or c2.categoryname ilike ('%%' || %s || '%%')
            or c3.categoryname ilike ('%%' || %s || '%%')
            or coffeetypename ilike ('%%' || %s || '%%')
            or milkkindname ilike ('%%' || %s || '%%')
            or reviewer ilike ('%%' || %s || '%%'))
            and (age(mi.reviewdate) < '10 years' or mi.reviewdate is null)
         order by reviewdate asc nulls first
        """
        cur.execute(query, (searchString,) * 8)
        temp = cur.fetchall()
        for i in temp:
            result.append(menuitem(i))
        cur.close()
        return result
    except psycopg2.Error as e:
        print("Connecting has problem")
        print(e)
        return []
    finally:
        cur.close()
        conn.close()

def get_Category(value):
    conn = openConnection()
    cursor = conn.cursor()
    query = "SELECT CategoryID FROM Category WHERE CategoryName = INITCAP(%s);"
    try:
        cursor.execute(query, (value,))
        result = cursor.fetchone()
        return result[0] if result else None
    except Exception as e:
        print(e)
        return None
    finally:
        cursor.close()
        conn.close()

def get_CoffeeType(value):
    conn = openConnection()
    cursor = conn.cursor()
    query = "SELECT CoffeeTypeID FROM CoffeeType WHERE CoffeeTypeName = INITCAP(%s);"
    try:
        cursor.execute(query, (value,))
        result = cursor.fetchone()
        return result[0] if result else None
    except Exception as e:
        print(e)
        return None
    finally:
        cursor.close()
        conn.close()

def get_MilkKind(value):
    conn = openConnection()
    cursor = conn.cursor()
    query = "SELECT MilkKindID FROM MilkKind WHERE MilkKindName = INITCAP(%s);"
    try:
        cursor.execute(query, (value,))
        result = cursor.fetchone()
        return result[0] if result else None
    except Exception as e:
        print(e)
        return None
    finally:
        cursor.close()
        conn.close()

def get_Reviewer(value):
    conn = openConnection()
    cursor = conn.cursor()
    query = "SELECT StaffID FROM Staff WHERE StaffID = LOWER(%s);"
    try:
        cursor.execute(query, (value,))
        result = cursor.fetchone()
        return result[0] if result else None
    except Exception as e:
        print(e)
        return None
    finally:
        cursor.close()
        conn.close()

'''
Add a new menu item
'''
def addMenuItem(name, description, categoryone, categorytwo, categorythree, coffeetype, milkkind, price):
    
    category_one = get_Category(categoryone)
    category_two = get_Category(categorytwo) if categorytwo else None
    category_three = get_Category(categorythree) if categorythree else None
    coffee_type = get_CoffeeType(coffeetype) if coffeetype else None
    milk_kind = get_MilkKind(milkkind) if milkkind else None
    
    if milk_kind and not coffee_type:
        print("A coffee type must be provided when a milk kind is specified.")
        return False

    conn = openConnection()
    cursor = conn.cursor()
    try:
        cursor.callproc('add_menu_item', [name, description, category_one, category_two, category_three, coffee_type, milk_kind, price]) 
        conn.commit()  
        return True
    
    except Exception as e:
        conn.rollback() 
        print(e)
        return False
    finally:
        cursor.close()
        conn.close()



'''
Update an existing menu item
'''
def updateMenuItem(menuitem_id, name, description, categoryone, categorytwo, categorythree, coffeetype, milkkind, price, reviewdate, reviewer):
    
    category_one = get_Category(categoryone)
    category_two = get_Category(categorytwo) if categorytwo else None
    category_three = get_Category(categorythree) if categorythree else None
    coffee_type = get_CoffeeType(coffeetype) if coffeetype else None
    milk_kind = get_MilkKind(milkkind) if milkkind else None
    reviewdate_ = reviewdate if reviewdate else None
    reviewer_ = get_Reviewer(reviewer) if reviewer else None

    if milk_kind and not coffee_type:
        print("A coffee type must be provided when a milk kind is specified.")
        return False

    conn = openConnection()
    cursor = conn.cursor()
    try:
        cursor.callproc('update_menu_item', [menuitem_id, name, description, category_one, category_two, category_three, coffee_type, milk_kind, price, reviewdate_, reviewer_])
        conn.commit()  
        return True
    except Exception as e:
        conn.rollback()  
        print(e)
        return False
    finally:
        cursor.close()
        conn.close()

