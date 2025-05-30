using UnityEngine;

public class SimpleFPSController : MonoBehaviour
{
    [Header("Movement")]
    public float walkSpeed = 5f;
    public float sprintSpeed = 10f;
    public float jumpHeight = 1.5f;
    public float gravity = -9.81f;

    [Header("Look")]
    public Transform cameraHolder;
    public float mouseSensitivity = 2f;
    public float maxLookAngle = 90f;

    [Header("FOV")]
    public Camera playerCamera;
    public float normalFOV = 60f;
    public float sprintFOV = 75f;
    public float fovSmoothSpeed = 10f;

    private CharacterController controller;
    private float yVelocity = 0f;
    private float verticalLook = 0f;

    void Start()
    {
        controller = GetComponent<CharacterController>();
        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;

        if (playerCamera != null)
            playerCamera.fieldOfView = normalFOV;
    }

    void Update()
    {
        // Mouse look
        float mouseX = Input.GetAxis("Mouse X") * mouseSensitivity;
        float mouseY = Input.GetAxis("Mouse Y") * mouseSensitivity;

        transform.Rotate(Vector3.up * mouseX);

        verticalLook -= mouseY;
        verticalLook = Mathf.Clamp(verticalLook, -maxLookAngle, maxLookAngle);
        cameraHolder.localRotation = Quaternion.Euler(verticalLook, 0f, 0f);

        // Movement
        float moveX = Input.GetAxis("Horizontal");
        float moveZ = Input.GetAxis("Vertical");

        float speed = Input.GetKey(KeyCode.LeftShift) ? sprintSpeed : walkSpeed;
        Vector3 move = transform.right * moveX + transform.forward * moveZ;

        // Gravity
        if (controller.isGrounded && yVelocity < 0)
        {
            yVelocity = -2f; // small downward force to stay grounded
        }

        // Jump
        if (Input.GetKeyDown(KeyCode.Space) && controller.isGrounded)
        {
            yVelocity = Mathf.Sqrt(jumpHeight * -2f * gravity);
        }

        yVelocity += gravity * Time.deltaTime;

        Vector3 velocity = move * speed + Vector3.up * yVelocity;

        controller.Move(velocity * Time.deltaTime);

        // FOV Lerp
        if (playerCamera != null)
        {
            float targetFOV = Input.GetKey(KeyCode.LeftShift) ? sprintFOV : normalFOV;
            playerCamera.fieldOfView = Mathf.Lerp(playerCamera.fieldOfView, targetFOV, Time.deltaTime * fovSmoothSpeed);
        }
    }
}
