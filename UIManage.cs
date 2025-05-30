using UnityEngine;
using UnityEngine.UI;

public class InventoryUIManager : MonoBehaviour
{
    public GameObject inventoryUI;
    public Image[] slotImages; // Assign Slot0 to Slot4 here in Inspector
    public Image axeImage;
    public Image pickaxeImage;
    public Image crosshairImage; // Drag your Crosshair image here

    public float swingDistance = 30f; // pixels to move down
    public float swingSpeed = 5f;     // speed of animation

    private Image currentToolImage;

    public int selectedSlot = 0;
    private bool isInventoryOpen = false;
    private bool isSwinging = false;
    private Vector3 originalPos;
    private Vector3 targetPos;
    private float swingProgress = 0f;

    private Color selectedColor = Color.white;
    private Color unselectedColor = new Color(0.53f, 0.53f, 0.53f); // #878787

    void Start()
    {
        inventoryUI.SetActive(false);
        UpdateSlotColors();
        UpdateToolVisibility();
    }

    void Update()
    {
        // Toggle inventory with E
        if (Input.GetKeyDown(KeyCode.E))
        {
            isInventoryOpen = !isInventoryOpen;
            inventoryUI.SetActive(isInventoryOpen);
        }

        // Hotbar keys
        if (Input.GetKeyDown(KeyCode.Alpha1)) { selectedSlot = 0; UpdateSlotColors(); UpdateToolVisibility(); }
        if (Input.GetKeyDown(KeyCode.Alpha2)) { selectedSlot = 1; UpdateSlotColors(); UpdateToolVisibility(); }
        if (Input.GetKeyDown(KeyCode.Alpha3)) { selectedSlot = 2; UpdateSlotColors(); UpdateToolVisibility(); }
        if (Input.GetKeyDown(KeyCode.Alpha4)) { selectedSlot = 3; UpdateSlotColors(); UpdateToolVisibility(); }
        if (Input.GetKeyDown(KeyCode.Alpha5)) { selectedSlot = 4; UpdateSlotColors(); UpdateToolVisibility(); }

        // Mouse click triggers swing
        if (Input.GetMouseButtonDown(0) && currentToolImage != null)
        {
            if (!isSwinging)
            {
                originalPos = currentToolImage.rectTransform.anchoredPosition;
                targetPos = originalPos + new Vector3(0, -swingDistance, 0);
                swingProgress = 0f;
                isSwinging = true;
            }
        }

        // Animate swing
        if (isSwinging && currentToolImage != null)
        {
            swingProgress += Time.deltaTime * swingSpeed;

            if (swingProgress <= 0.5f)
            {
                // Move down
                currentToolImage.rectTransform.anchoredPosition = Vector3.Lerp(originalPos, targetPos, swingProgress * 2);
            }
            else if (swingProgress <= 1f)
            {
                // Move back up
                currentToolImage.rectTransform.anchoredPosition = Vector3.Lerp(targetPos, originalPos, (swingProgress - 0.5f) * 2);
            }
            else
            {
                // Done swinging
                currentToolImage.rectTransform.anchoredPosition = originalPos;
                isSwinging = false;
            }
        }
    }

    void UpdateSlotColors()
    {
        for (int i = 0; i < slotImages.Length; i++)
        {
            slotImages[i].color = (i == selectedSlot) ? selectedColor : unselectedColor;
        }
    }

    void UpdateToolVisibility()
    {
        axeImage.gameObject.SetActive(selectedSlot == 0);
        pickaxeImage.gameObject.SetActive(selectedSlot == 1);

        if (selectedSlot == 0)
            currentToolImage = axeImage;
        else if (selectedSlot == 1)
            currentToolImage = pickaxeImage;
        else
            currentToolImage = null;
    }
}
