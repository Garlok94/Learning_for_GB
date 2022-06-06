total_km = int(input("Enter the total km: "))
hml = int(input("How many km are left: "))
day = 1
all_km = total_km
while total_km < hml:
    total_km = total_km + 0.1 * total_km
    day += 1
    all_km = all_km + a
print(f"You will finish at %.d day" % day)
