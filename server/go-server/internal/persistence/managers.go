package persistence

// Managers share the Store connection pool; business transactions remain explicit.
type RoleManager struct{ store *Store }

func (s *Store) RoleManager() *RoleManager { return &RoleManager{store: s} }

type InventoryManager struct{ store *Store }

func (s *Store) InventoryManager() *InventoryManager { return &InventoryManager{store: s} }

type EquipmentManager struct{ store *Store }

func (s *Store) EquipmentManager() *EquipmentManager { return &EquipmentManager{store: s} }

type RewardManager struct{ store *Store }

func (s *Store) RewardManager() *RewardManager { return &RewardManager{store: s} }

type TitleManager struct{ store *Store }

func (s *Store) TitleManager() *TitleManager { return &TitleManager{store: s} }

type TaskManager struct{ store *Store }

func (s *Store) TaskManager() *TaskManager { return &TaskManager{store: s} }

type BattleManager struct{ store *Store }

func (s *Store) BattleManager() *BattleManager { return &BattleManager{store: s} }

type ShopManager struct{ store *Store }

func (s *Store) ShopManager() *ShopManager { return &ShopManager{store: s} }

type MailManager struct{ store *Store }

func (s *Store) MailManager() *MailManager { return &MailManager{store: s} }

type WalletManager struct{ store *Store }

func (s *Store) WalletManager() *WalletManager { return &WalletManager{store: s} }

type TrainingManager struct{ store *Store }

func (s *Store) TrainingManager() *TrainingManager { return &TrainingManager{store: s} }

type ItemManager struct{ store *Store }

func (s *Store) ItemManager() *ItemManager { return &ItemManager{store: s} }
