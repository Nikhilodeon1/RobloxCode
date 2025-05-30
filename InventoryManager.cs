using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using TMPro;

[System.Serializable]
public class InventorySlotUI
{
    public Image icon;
    public TextMeshProUGUI countText;
}

public class InventoryManager : MonoBehaviour
{
    [Header("UI References")]
    public List<InventorySlotUI> uiSlots; // Already filled with 20 entries

    [Header("Item Sprites")]
    public Sprite woodSprite;
    public Sprite stoneSprite;
    // Add more as needed

    private Dictionary<string, InventoryItem> inventory = new Dictionary<string, InventoryItem>();

    void Start()
    {
        UpdateUI(); // Clear UI on start
    }

    public void AddItem(string itemName, int amount)
    {
        if (inventory.ContainsKey(itemName))
        {
            inventory[itemName].count += amount;
        }
        else
        {
            Sprite icon = GetIconForItem(itemName);
            inventory[itemName] = new InventoryItem(itemName, amount, icon);
        }

        UpdateUI();
    }

    private Sprite GetIconForItem(string itemName)
    {
        return itemName switch
        {
            "Wood" => woodSprite,
            "Stone" => stoneSprite,
            _ => null
        };
    }

    private void UpdateUI()
    {
        int i = 0;
        foreach (var item in inventory.Values)
        {
            if (i >= uiSlots.Count) break;

            var slot = uiSlots[i];
            slot.icon.sprite = item.icon;
            slot.icon.enabled = true;
            slot.countText.text = item.count.ToString();
            i++;
        }

        // Clear remaining unused slots
        for (; i < uiSlots.Count; i++)
{
    uiSlots[i].icon.sprite = null;
    uiSlots[i].icon.enabled = false;
    uiSlots[i].countText.text = "";
}

    }

    private class InventoryItem
    {
        public string name;
        public int count;
        public Sprite icon;

        public InventoryItem(string name, int count, Sprite icon)
        {
            this.name = name;
            this.count = count;
            this.icon = icon;
        }
    }
}
