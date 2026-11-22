// the CRUD map

| TABLE           | C  | R | U | D  | PAGES                                            |    WHO     
|-----------------|---|---|---|-----|--------------------------------------------------|------------------------------------------------|
| RESIDENT        | ✓ | ✓ | ✓ | ✗ | resident-list, resident-profile, resident-for    | Resident: R, U own profile<br>Personnel: C, R U |
| USER_ACCOUNT    | ✓ | ✓ | ✓ | ✗ | login, account-settings, account-management      | Personnel: C, R, U<br>Resident: R, U own account|
| SERVICE_CONCERN | ✓ | ✓ | ✓ | ✗ | concern-list, concern-details, concern-form      | Resident: C, R own<br>Personnel: C, R, U        |
| PERSONNEL       | ✓ | ✓ | ✓ | ✗ | personnel-list, personnel-profile, personnel-form| Personnel: R<br>Authorized Personnel: C, R, U   |
| ASSIGNMENT      | ✓ | ✓ | ✓ | ✗ | assignment-list, assign-concern-form             | Personnel: C, R, U                              |
| SERVICE_ACTION  | ✓ | ✓ | ✓ | ✗ | service-history, add-service-action            | Personnel: C, R<br>Resident: R own concern updates|
| WATER_SCHEDULE  | ✓ | ✓ | ✓ | ✗ | water-schedule-list, schedule-form               | Personnel: C, R, U<br>Resident: R               |
| NOTIFICATION    | ✓ | ✓ | ✓ | ✗ | notification-list, create-notification-form    | Personnel: C, R, U<br>Resident: R own notifications|